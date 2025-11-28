#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
摄像头节点 - 使用电脑摄像头捕获图像并发布到ROS话题
"""

import rospy
import cv2
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError
import numpy as np

class CameraNode:
    def __init__(self):
        rospy.init_node('camera_node', anonymous=False)
        
        # 参数
        self.camera_id = rospy.get_param('~camera_id', 0)
        self.frame_rate = rospy.get_param('~frame_rate', 30)
        self.image_width = rospy.get_param('~image_width', 640)
        self.image_height = rospy.get_param('~image_height', 480)
        
        # 发布者
        self.image_pub = rospy.Publisher('/camera/image_raw', Image, queue_size=1)
        
        # CV Bridge
        self.bridge = CvBridge()
        
        # 打开摄像头
        self.cap = None
        self.open_camera()
        
    def open_camera(self):
        """打开摄像头"""
        rospy.loginfo(f"正在打开摄像头 (ID: {self.camera_id})...")
        
        # WSL2 需要使用 V4L2 后端
        self.cap = cv2.VideoCapture(self.camera_id, cv2.CAP_V4L2)
        
        if not self.cap.isOpened():
            rospy.logerr("无法打开摄像头!")
            return False
        
        # WSL2 使用 MJPEG 格式更稳定
        self.cap.set(cv2.CAP_PROP_FOURCC, cv2.VideoWriter_fourcc('M','J','P','G'))
        self.cap.set(cv2.CAP_PROP_FRAME_WIDTH, self.image_width)
        self.cap.set(cv2.CAP_PROP_FRAME_HEIGHT, self.image_height)
        self.cap.set(cv2.CAP_PROP_FPS, self.frame_rate)
        
        actual_width = self.cap.get(cv2.CAP_PROP_FRAME_WIDTH)
        actual_height = self.cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
        actual_fps = self.cap.get(cv2.CAP_PROP_FPS)
        
        rospy.loginfo(f"摄像头已打开: {actual_width}x{actual_height} @ {actual_fps}fps (MJPEG模式)")
        return True
    
    def run(self):
        """主循环"""
        rate = rospy.Rate(self.frame_rate)
        
        rospy.loginfo("摄像头节点正在运行，发布到 /camera/image_raw ...")
        
        while not rospy.is_shutdown():
            if self.cap is None or not self.cap.isOpened():
                rospy.logwarn("摄像头未打开，尝试重新打开...")
                if not self.open_camera():
                    rospy.sleep(1)
                    continue
            
            ret, frame = self.cap.read()
            
            if not ret:
                rospy.logwarn("读取摄像头帧失败")
                continue
            
            try:
                # 转换为ROS图像消息
                img_msg = self.bridge.cv2_to_imgmsg(frame, "bgr8")
                img_msg.header.stamp = rospy.Time.now()
                img_msg.header.frame_id = "camera_link"
                
                # 发布图像
                self.image_pub.publish(img_msg)
                
            except CvBridgeError as e:
                rospy.logerr(f"CV Bridge错误: {e}")
            
            rate.sleep()
    
    def shutdown(self):
        """关闭节点"""
        rospy.loginfo("关闭摄像头节点...")
        if self.cap is not None:
            self.cap.release()

def main():
    try:
        node = CameraNode()
        rospy.on_shutdown(node.shutdown)
        node.run()
    except rospy.ROSInterruptException:
        pass

if __name__ == '__main__':
    main()
