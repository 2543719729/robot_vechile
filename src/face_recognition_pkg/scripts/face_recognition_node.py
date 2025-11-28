#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
人脸识别节点 - 交互式人脸识别
功能:
1. 询问用户是否进行识别
2. 用户输入yes后，截取摄像头图片
3. 进行人脸识别并打印识别结果
"""

import os
import sys
import pickle
import threading
import rospy
import cv2
import numpy as np
import face_recognition
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError
from std_msgs.msg import String

class FaceRecognitionNode:
    def __init__(self):
        rospy.init_node('face_recognition_node', anonymous=False)
        
        # 参数
        self.encoding_file = rospy.get_param('~encoding_file', '')
        self.tolerance = rospy.get_param('~tolerance', 0.5)  # 人脸匹配容差，越小越严格
        self.camera_topic = rospy.get_param('~camera_topic', '/camera/image_raw')
        self.use_direct_camera = rospy.get_param('~use_direct_camera', True)  # 是否直接使用摄像头
        self.camera_id = rospy.get_param('~camera_id', 0)
        
        # CV Bridge
        self.bridge = CvBridge()
        
        # 当前图像帧
        self.current_frame = None
        self.frame_lock = threading.Lock()
        
        # 加载人脸编码数据
        self.known_encodings = []
        self.known_names = []
        self.load_encodings()
        
        # 如果不使用直接摄像头，订阅摄像头话题
        if not self.use_direct_camera:
            self.image_sub = rospy.Subscriber(
                self.camera_topic, 
                Image, 
                self.image_callback,
                queue_size=1
            )
            rospy.loginfo(f"订阅摄像头话题: {self.camera_topic}")
        
        # 发布识别结果
        self.result_pub = rospy.Publisher('/face_recognition/result', String, queue_size=10)
        
        # 直接摄像头
        self.cap = None
        if self.use_direct_camera:
            self.init_direct_camera()
    
    def init_direct_camera(self):
        """初始化直接摄像头访问"""
        rospy.loginfo(f"初始化摄像头 (ID: {self.camera_id})...")
        # WSL2 需要使用 V4L2 后端和 MJPEG 格式
        self.cap = cv2.VideoCapture(self.camera_id, cv2.CAP_V4L2)
        if not self.cap.isOpened():
            rospy.logwarn("无法打开摄像头，将尝试订阅ROS话题")
            self.use_direct_camera = False
            self.image_sub = rospy.Subscriber(
                self.camera_topic, 
                Image, 
                self.image_callback,
                queue_size=1
            )
        else:
            # 使用 MJPEG 格式 (WSL2 USB/IP 更稳定)
            self.cap.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc('M','J','P','G'))
            self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
            self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
            self.cap.set(cv2.CAP_PROP_FPS, 30)
            rospy.loginfo("摄像头初始化成功 (MJPEG 模式)")
    
    def load_encodings(self):
        """加载人脸编码数据"""
        if not self.encoding_file:
            # 默认路径
            script_dir = os.path.dirname(os.path.abspath(__file__))
            pkg_dir = os.path.dirname(script_dir)
            self.encoding_file = os.path.join(pkg_dir, "data", "face_encodings.pkl")
        
        rospy.loginfo(f"加载人脸编码数据: {self.encoding_file}")
        
        if not os.path.exists(self.encoding_file):
            rospy.logwarn(f"人脸编码文件不存在: {self.encoding_file}")
            rospy.logwarn("请先运行 train_faces.py 进行训练!")
            return False
        
        try:
            with open(self.encoding_file, "rb") as f:
                data = pickle.load(f)
                self.known_encodings = data["encodings"]
                self.known_names = data["names"]
            
            unique_names = list(set(self.known_names))
            rospy.loginfo(f"成功加载 {len(unique_names)} 个人的 {len(self.known_encodings)} 个人脸编码")
            rospy.loginfo(f"已注册人员: {', '.join(unique_names)}")
            return True
            
        except Exception as e:
            rospy.logerr(f"加载人脸编码失败: {e}")
            return False
    
    def image_callback(self, msg):
        """图像回调函数"""
        try:
            cv_image = self.bridge.imgmsg_to_cv2(msg, "bgr8")
            with self.frame_lock:
                self.current_frame = cv_image.copy()
        except CvBridgeError as e:
            rospy.logerr(f"CV Bridge错误: {e}")
    
    def capture_frame(self):
        """捕获当前帧"""
        if self.use_direct_camera and self.cap is not None:
            # WSL2 USB/IP 可能需要多次尝试
            import time
            for attempt in range(10):
                ret, frame = self.cap.read()
                if ret and frame is not None:
                    return frame
                time.sleep(0.1)
            rospy.logwarn("从摄像头读取帧失败")
            return None
        else:
            with self.frame_lock:
                if self.current_frame is not None:
                    return self.current_frame.copy()
            return None
    
    def recognize_faces(self, frame):
        """
        识别图像中的人脸
        
        Args:
            frame: BGR格式的图像
            
        Returns:
            识别到的人名列表
        """
        if frame is None:
            return []
        
        if not self.known_encodings:
            rospy.logwarn("没有已知的人脸编码数据!")
            return []
        
        # 转换为RGB格式 (face_recognition需要RGB)
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        
        # 缩小图像以加快处理速度
        small_frame = cv2.resize(rgb_frame, (0, 0), fx=0.5, fy=0.5)
        
        # 检测人脸位置
        face_locations = face_recognition.face_locations(small_frame, model="hog")
        
        if not face_locations:
            rospy.loginfo("未检测到人脸")
            return []
        
        rospy.loginfo(f"检测到 {len(face_locations)} 张人脸")
        
        # 获取人脸编码
        face_encodings = face_recognition.face_encodings(small_frame, face_locations)
        
        recognized_names = []
        
        for face_encoding in face_encodings:
            # 计算与已知人脸的距离
            distances = face_recognition.face_distance(self.known_encodings, face_encoding)
            
            # 找到最小距离
            if len(distances) > 0:
                min_distance_idx = np.argmin(distances)
                min_distance = distances[min_distance_idx]
                
                if min_distance < self.tolerance:
                    name = self.known_names[min_distance_idx]
                    confidence = (1 - min_distance) * 100
                    recognized_names.append((name, confidence))
                    rospy.loginfo(f"识别到: {name} (置信度: {confidence:.1f}%)")
                else:
                    recognized_names.append(("未知", 0))
                    rospy.loginfo("检测到未知人脸")
        
        return recognized_names
    
    def print_recognition_result(self, names):
        """打印识别结果"""
        print("\n" + "=" * 50)
        print("           人脸识别结果")
        print("=" * 50)
        
        if not names:
            print("  未检测到任何人脸")
        else:
            for i, (name, confidence) in enumerate(names, 1):
                if name == "未知":
                    print(f"  人物 {i}: 未知人员")
                else:
                    print(f"  人物 {i}: {name} (置信度: {confidence:.1f}%)")
        
        print("=" * 50 + "\n")
        
        # 发布结果到ROS话题
        result_str = ", ".join([name for name, _ in names]) if names else "无"
        self.result_pub.publish(String(data=result_str))
    
    def save_captured_image(self, frame, names):
        """保存捕获的图像"""
        if frame is None:
            return
        
        # 保存目录
        script_dir = os.path.dirname(os.path.abspath(__file__))
        pkg_dir = os.path.dirname(script_dir)
        save_dir = os.path.join(pkg_dir, "captured_images")
        
        if not os.path.exists(save_dir):
            os.makedirs(save_dir)
        
        # 文件名使用时间戳
        import time
        timestamp = time.strftime("%Y%m%d_%H%M%S")
        filename = f"captured_{timestamp}.jpg"
        filepath = os.path.join(save_dir, filename)
        
        cv2.imwrite(filepath, frame)
        rospy.loginfo(f"图像已保存: {filepath}")
    
    def run_interactive(self):
        """交互式运行模式"""
        print("\n" + "=" * 50)
        print("       人脸识别系统 - 交互模式")
        print("=" * 50)
        print("已注册人员:", ", ".join(set(self.known_names)) if self.known_names else "无")
        print("=" * 50)
        
        # 等待摄像头准备就绪
        rospy.sleep(1.0)
        
        while not rospy.is_shutdown():
            print("\n是否要进行人脸识别? (输入 'yes' 进行识别, 'quit' 退出)")
            
            try:
                user_input = input(">>> ").strip().lower()
            except EOFError:
                break
            
            if user_input in ['quit', 'q', 'exit']:
                print("退出人脸识别系统")
                break
            
            if user_input in ['yes', 'y', '是']:
                print("\n正在捕获图像...")
                
                # 捕获多帧以确保获取清晰图像
                frame = None
                for _ in range(5):
                    frame = self.capture_frame()
                    if frame is not None:
                        break
                    rospy.sleep(0.1)
                
                if frame is None:
                    print("错误: 无法获取摄像头图像!")
                    print("请确保:")
                    print("  1. 摄像头已连接")
                    print("  2. 摄像头节点正在运行")
                    continue
                
                print("正在识别人脸...")
                
                # 进行人脸识别
                names = self.recognize_faces(frame)
                
                # 打印结果
                self.print_recognition_result(names)
                
                # 保存图像
                self.save_captured_image(frame, names)
            
            elif user_input == 'reload':
                # 重新加载人脸编码
                print("重新加载人脸编码数据...")
                self.load_encodings()
            
            else:
                print("请输入 'yes' 进行识别，或 'quit' 退出")
    
    def shutdown(self):
        """关闭节点"""
        rospy.loginfo("关闭人脸识别节点...")
        if self.cap is not None:
            self.cap.release()

def main():
    try:
        node = FaceRecognitionNode()
        rospy.on_shutdown(node.shutdown)
        node.run_interactive()
    except rospy.ROSInterruptException:
        pass
    except KeyboardInterrupt:
        print("\n用户中断")

if __name__ == '__main__':
    main()
