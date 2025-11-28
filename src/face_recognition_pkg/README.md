# 人脸识别 ROS 包 (face_recognition_pkg)

## 功能描述

本包提供基于 ROS 的人脸识别功能，可以通过电脑摄像头识别不同的人。

## 已注册人员

- **李亚鑫** (person1)
- **韩欣言** (person2)  
- **韩沐容** (person3)

## 依赖安装

```bash
# 安装Python依赖
pip3 install face_recognition opencv-python numpy

# 如果face_recognition安装失败，需要先安装dlib依赖
sudo apt-get install cmake libboost-python-dev libboost-system-dev
pip3 install dlib
pip3 install face_recognition
```

## 使用方法

### 1. 训练人脸模型

首先需要对person目录中的人脸图片进行编码：

```bash
# 在工作空间中
cd ~/Documents/robot_learning
source devel/setup.bash

# 运行训练脚本
rosrun face_recognition_pkg train_faces.py
```

### 2. 运行人脸识别

**方法一：配合导航系统使用（推荐）**
```bash
# 终端1：启动导航系统（包含摄像头和RViz）
roslaunch bobac3_navigation demo_nav_2d.launch

# 终端2：启动人脸识别（订阅摄像头话题）
roslaunch face_recognition_pkg face_recognition_topic.launch
```

**方法二：独立运行（直接使用摄像头）**
```bash
# 直接使用摄像头进行识别
roslaunch face_recognition_pkg face_recognition.launch
```

**方法三：完整系统**
```bash
# 启动摄像头节点和识别节点
roslaunch face_recognition_pkg full_system.launch
```

### 3. 使用说明

1. 启动后，系统会显示已注册的人员列表
2. 输入 `yes` 进行人脸识别
3. 系统会捕获摄像头图像，识别人脸，并打印结果
4. 输入 `quit` 退出系统

## 参数配置

| 参数 | 默认值 | 说明 |
|------|--------|------|
| camera_id | 0 | 摄像头设备ID |
| tolerance | 0.5 | 人脸匹配容差 (0.4-0.6, 越小越严格) |
| use_direct_camera | true | 是否直接使用摄像头 |

## 话题

- `/camera/image_raw` - 摄像头图像 (sensor_msgs/Image)
- `/face_recognition/result` - 识别结果 (std_msgs/String)

## 文件结构

```
face_recognition_pkg/
├── CMakeLists.txt
├── package.xml
├── README.md
├── data/
│   └── face_encodings.pkl    # 人脸编码数据 (训练后生成)
├── launch/
│   ├── camera.launch         # 摄像头节点
│   ├── face_recognition.launch   # 人脸识别节点
│   └── full_system.launch    # 完整系统
└── scripts/
    ├── camera_node.py        # 摄像头节点
    ├── face_recognition_node.py  # 人脸识别节点
    └── train_faces.py        # 训练脚本
```

## 添加新人员

1. 在 `~/Documents/robot_learning/person/` 目录下创建新文件夹
2. 在新文件夹中放入人脸照片 (jpg/png格式)
3. 创建一个以人名命名的 `.txt` 文件 (例如: `张三.txt`)
4. 重新运行训练脚本: `rosrun face_recognition_pkg train_faces.py`
