#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
人脸训练脚本 - 对person目录中的人脸图片进行编码并保存
用法: python train_faces.py 或 rosrun face_recognition_pkg train_faces.py
"""

import os
import sys
import pickle
import face_recognition
import cv2
import numpy as np

def get_person_name_from_dir(person_dir):
    """
    从person目录中获取人名
    通过查找.txt文件来获取人名
    """
    for file in os.listdir(person_dir):
        if file.endswith('.txt'):
            # 文件名（不含扩展名）即为人名
            return os.path.splitext(file)[0]
    return None

def train_faces(person_base_dir, output_file):
    """
    训练人脸编码
    
    Args:
        person_base_dir: person目录的路径，包含person1, person2, person3等子目录
        output_file: 保存编码数据的文件路径
    """
    known_encodings = []
    known_names = []
    
    print("=" * 50)
    print("开始训练人脸识别模型...")
    print("=" * 50)
    
    # 遍历person目录下的所有子目录
    if not os.path.exists(person_base_dir):
        print(f"错误: 目录 {person_base_dir} 不存在!")
        return False
    
    person_dirs = sorted([d for d in os.listdir(person_base_dir) 
                          if os.path.isdir(os.path.join(person_base_dir, d))])
    
    if not person_dirs:
        print(f"错误: 在 {person_base_dir} 中没有找到人员目录!")
        return False
    
    for person_dir_name in person_dirs:
        person_dir = os.path.join(person_base_dir, person_dir_name)
        
        # 获取人名
        person_name = get_person_name_from_dir(person_dir)
        if person_name is None:
            print(f"警告: 在 {person_dir} 中没有找到.txt文件，跳过...")
            continue
        
        print(f"\n正在处理: {person_name}")
        
        # 获取所有图片文件
        image_files = [f for f in os.listdir(person_dir) 
                       if f.lower().endswith(('.jpg', '.jpeg', '.png', '.bmp'))]
        
        if not image_files:
            print(f"  警告: 没有找到图片文件，跳过...")
            continue
        
        encoded_count = 0
        for image_file in image_files:
            image_path = os.path.join(person_dir, image_file)
            print(f"  处理图片: {image_file}", end=" ... ")
            
            try:
                # 加载图片
                image = face_recognition.load_image_file(image_path)
                
                # 检测人脸并获取编码
                face_locations = face_recognition.face_locations(image, model="hog")
                
                if len(face_locations) == 0:
                    print("未检测到人脸")
                    continue
                
                if len(face_locations) > 1:
                    print(f"检测到{len(face_locations)}张人脸，使用第一张")
                
                # 获取人脸编码
                face_encodings = face_recognition.face_encodings(image, face_locations)
                
                if face_encodings:
                    known_encodings.append(face_encodings[0])
                    known_names.append(person_name)
                    encoded_count += 1
                    print("成功")
                else:
                    print("编码失败")
                    
            except Exception as e:
                print(f"错误: {str(e)}")
        
        print(f"  {person_name}: 成功编码 {encoded_count}/{len(image_files)} 张图片")
    
    if not known_encodings:
        print("\n错误: 没有成功编码任何人脸!")
        return False
    
    # 保存编码数据
    print(f"\n保存编码数据到: {output_file}")
    
    # 确保输出目录存在
    output_dir = os.path.dirname(output_file)
    if output_dir and not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    data = {
        "encodings": known_encodings,
        "names": known_names
    }
    
    with open(output_file, "wb") as f:
        pickle.dump(data, f)
    
    # 打印统计信息
    unique_names = list(set(known_names))
    print("\n" + "=" * 50)
    print("训练完成!")
    print("=" * 50)
    print(f"总共识别的人数: {len(unique_names)}")
    print(f"人员列表: {', '.join(unique_names)}")
    print(f"总编码数量: {len(known_encodings)}")
    print("=" * 50)
    
    return True

def main():
    # 获取脚本所在目录
    script_dir = os.path.dirname(os.path.abspath(__file__))
    pkg_dir = os.path.dirname(script_dir)
    
    # 设置路径
    # person目录在工作空间根目录下
    workspace_dir = os.path.dirname(os.path.dirname(pkg_dir))
    person_base_dir = os.path.join(workspace_dir, "person")
    
    # 输出文件保存在包的data目录下
    output_dir = os.path.join(pkg_dir, "data")
    output_file = os.path.join(output_dir, "face_encodings.pkl")
    
    print(f"人脸图片目录: {person_base_dir}")
    print(f"编码输出文件: {output_file}")
    
    success = train_faces(person_base_dir, output_file)
    
    if success:
        print("\n人脸训练完成! 可以运行识别节点了。")
        return 0
    else:
        print("\n人脸训练失败!")
        return 1

if __name__ == "__main__":
    sys.exit(main())
