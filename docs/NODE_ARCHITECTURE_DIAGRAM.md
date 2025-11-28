# Bobac3 机器人系统节点架构图

本文档提供系统各模块之间的详细节点通信关系图，使用Mermaid格式绘制。

---

## 1. 整体系统架构

```mermaid
flowchart TB
    subgraph 感知层["🔍 感知层"]
        LIDAR[("激光雷达<br/>/scan")]
        CAMERA[("摄像头<br/>/camera/image_raw")]
        MIC[("麦克风<br/>PCM音频")]
        ODOM[("里程计<br/>/odom")]
    end

    subgraph 处理层["⚙️ 处理层"]
        AMCL["amcl<br/>自适应蒙特卡洛定位"]
        GMAPPING["gmapping<br/>SLAM建图"]
        FACE_REC["face_recognition_node<br/>人脸识别"]
        AIUI["robot_aiui<br/>语音交互"]
    end

    subgraph 决策层["🧠 决策层"]
        MOVE_BASE["move_base<br/>导航核心"]
        NAV_GOAL["nav_goal<br/>目标调度"]
        SEMANTEME["semanteme<br/>语义解析"]
    end

    subgraph 执行层["🦾 执行层"]
        CMD_VEL[("/cmd_vel<br/>速度指令")]
        TTS["TTS播放<br/>语音合成"]
        RESULT[("/face_recognition/result<br/>识别结果")]
    end

    %% 感知层连接
    LIDAR --> AMCL
    LIDAR --> GMAPPING
    LIDAR --> MOVE_BASE
    ODOM --> AMCL
    ODOM --> MOVE_BASE
    CAMERA --> FACE_REC
    MIC --> AIUI

    %% 处理层连接
    AMCL -->|/tf map→odom| MOVE_BASE
    GMAPPING -->|/map| AMCL
    FACE_REC --> RESULT
    AIUI -->|voice_aiui| SEMANTEME

    %% 决策层连接
    NAV_GOAL -->|/move_base/goal| MOVE_BASE
    SEMANTEME -->|导航意图| NAV_GOAL
    
    %% 执行层连接
    MOVE_BASE --> CMD_VEL
    AIUI --> TTS
```

---

## 2. 导航系统详细架构

```mermaid
flowchart LR
    subgraph 输入["📥 输入数据"]
        SCAN["/scan<br/>LaserScan"]
        ODOM["/odom<br/>Odometry"]
        MAP["/map<br/>OccupancyGrid"]
        GOAL["/move_base/goal<br/>目标点"]
    end

    subgraph MOVE_BASE["move_base 导航核心"]
        subgraph 全局层["全局规划"]
            GC["Global Costmap<br/>全局代价地图"]
            GP["NavfnROS<br/>A*全局规划器"]
        end
        
        subgraph 局部层["局部规划"]
            LC["Local Costmap<br/>局部代价地图"]
            LP["TEB Planner<br/>时间弹性带规划器"]
        end
        
        subgraph 恢复["恢复行为"]
            CLEAR["clear_costmap<br/>清除代价地图"]
            ROTATE["rotate_recovery<br/>原地旋转"]
        end
    end

    subgraph 输出["📤 输出"]
        CMD["/cmd_vel<br/>Twist"]
        PATH["/move_base/global_plan<br/>全局路径"]
        LOCAL["/move_base/local_plan<br/>局部路径"]
    end

    SCAN --> GC
    SCAN --> LC
    ODOM --> LC
    MAP --> GC
    GOAL --> GP

    GC --> GP
    GP --> LP
    LC --> LP
    
    LP --> CMD
    GP --> PATH
    LP --> LOCAL
    
    LP -.->|规划失败| CLEAR
    CLEAR -.-> ROTATE
    ROTATE -.-> LP
```

---

## 3. 人脸识别系统架构

```mermaid
flowchart TB
    subgraph 训练阶段["🎓 离线训练"]
        PERSON["person/目录<br/>人脸图片库"]
        TRAIN["train_faces.py<br/>训练脚本"]
        PKL["face_encodings.pkl<br/>128维编码数据"]
        
        PERSON -->|"1. 读取图片"| TRAIN
        TRAIN -->|"2. HOG检测"| TRAIN
        TRAIN -->|"3. 生成编码"| PKL
    end

    subgraph 运行阶段["🚀 在线识别"]
        CAM["camera_node<br/>摄像头节点"]
        IMG["/camera/image_raw<br/>图像话题"]
        NODE["face_recognition_node<br/>识别节点"]
        RES["/face_recognition/result<br/>识别结果"]
        
        CAM -->|"发布BGR8图像"| IMG
        IMG -->|"订阅图像"| NODE
        PKL -.->|"加载编码库"| NODE
        NODE -->|"发布结果"| RES
    end

    subgraph 算法流程["🔬 识别算法"]
        A["BGR→RGB转换"]
        B["图像缩放50%"]
        C["HOG人脸检测"]
        D["128维编码提取"]
        E["欧氏距离计算"]
        F["阈值判断<br/>tolerance=0.5"]
        
        A --> B --> C --> D --> E --> F
    end

    NODE --- 算法流程
```

---

## 4. 语音交互系统架构

```mermaid
flowchart TB
    subgraph 输入["🎤 输入"]
        TEXT["文本输入"]
        AUDIO["音频输入<br/>(PCM格式)"]
    end

    subgraph AIUI_SDK["科大讯飞 AIUI SDK"]
        AGENT["IAIUIAgent<br/>交互代理"]
        LISTENER["MyListener<br/>事件监听器"]
        
        subgraph 功能["核心功能"]
            WAKEUP["wakeup()<br/>唤醒"]
            WRITE_TEXT["writeText()<br/>文本语义"]
            WRITE_AUDIO["writeAudioFromLocal()<br/>音频语义"]
            TTS_FUNC["testTTs()<br/>语音合成"]
        end
    end

    subgraph ROS服务["🔧 ROS服务接口"]
        SRV_TTS["voice_tts<br/>文字转语音"]
        SRV_IAT["voice_iat<br/>语音转文字"]
        SRV_AIUI["voice_aiui<br/>语义理解"]
        SRV_SYNC["voice_up_sync<br/>动态实体同步"]
    end

    subgraph 输出["📢 输出"]
        WAV["tts.wav<br/>合成音频"]
        SEM["语义结果<br/>tech/iat/intent/slots"]
    end

    TEXT --> SRV_AIUI
    AUDIO --> SRV_IAT
    AUDIO --> SRV_AIUI

    SRV_TTS --> TTS_FUNC
    SRV_IAT --> WRITE_AUDIO
    SRV_AIUI --> WRITE_TEXT
    SRV_AIUI --> WRITE_AUDIO
    SRV_SYNC --> AGENT

    TTS_FUNC --> WAV
    WRITE_TEXT --> SEM
    WRITE_AUDIO --> SEM
```

---

## 5. TF坐标变换树

```mermaid
flowchart TB
    MAP["map<br/>(全局地图坐标系)"]
    ODOM["odom<br/>(里程计坐标系)"]
    BF["base_footprint<br/>(机器人地面投影)"]
    BL["base_link<br/>(机器人本体)"]
    
    subgraph 传感器["传感器坐标系"]
        FL["front_lidar_link"]
        RL["rear_lidar_link"]
        TC["top_camera_link"]
        BC["bottom_camera_link"]
    end
    
    subgraph 轮子["轮子坐标系"]
        LW["left_wheel_link"]
        RW["right_wheel_link"]
        FW["front_wheel_link"]
    end
    
    MAP -->|"amcl/gmapping<br/>发布"| ODOM
    ODOM -->|"底盘驱动<br/>发布"| BF
    BF -->|"robot_state_publisher"| BL
    
    BL --> FL
    BL --> RL
    BL --> TC
    BL --> BC
    BL --> LW
    BL --> RW
    BL --> FW
```

---

## 6. Launch文件依赖关系

```mermaid
flowchart TB
    subgraph 主启动["🚀 主启动文件"]
        DEMO["demo_nav_2d.launch<br/>完整导航演示"]
    end
    
    subgraph 子启动["📦 子启动文件"]
        GAZ["gazebo.launch<br/>仿真环境"]
        MAP_SRV["map_server.launch<br/>地图服务"]
        MB["move_base_sim.launch<br/>导航节点"]
        AMCL["amcl_sim.launch<br/>定位节点"]
    end
    
    subgraph 独立节点["🔧 独立节点"]
        CAM["camera_node.py<br/>摄像头"]
        RVIZ["rviz<br/>可视化"]
    end
    
    DEMO --> GAZ
    DEMO --> MAP_SRV
    DEMO --> MB
    DEMO --> AMCL
    DEMO --> CAM
    DEMO --> RVIZ
    
    subgraph 参数文件["📄 参数文件"]
        CCP["costmap_common_params.yaml"]
        LCP["local_costmap_params.yaml"]
        GCP["global_costmap_params.yaml"]
        TEB["teb_local_planner_params.yaml"]
        MBP["move_base_params.yaml"]
        NAV["navfn_global_planner_params.yaml"]
    end
    
    MB --> CCP
    MB --> LCP
    MB --> GCP
    MB --> TEB
    MB --> MBP
    MB --> NAV
```

---

## 7. 数据流向图

```mermaid
sequenceDiagram
    participant User as 用户
    participant Voice as 语音系统
    participant Nav as 导航系统
    participant Robot as 机器人底盘
    participant Face as 人脸识别

    Note over User,Face: 语音导航流程
    User->>Voice: "带我去卧室"
    Voice->>Voice: AIUI语义理解
    Voice->>Nav: robot_nav意图 + location=卧室
    Nav->>Nav: 查询位置坐标
    Nav->>Robot: /move_base/goal
    Robot->>Robot: 路径规划
    Robot->>Robot: /cmd_vel 执行
    Robot-->>Nav: 到达通知
    Nav-->>Voice: 导航完成
    Voice->>User: "已到达卧室"

    Note over User,Face: 人脸识别流程
    User->>Face: 触发识别
    Face->>Face: 捕获图像
    Face->>Face: HOG检测
    Face->>Face: 编码比对
    Face-->>User: "识别到: 张三 (85%)"
```

---

## 8. 系统状态机

```mermaid
stateDiagram-v2
    [*] --> 初始化
    
    初始化 --> 待命: 系统启动完成
    
    待命 --> 建图模式: 启动SLAM
    待命 --> 导航模式: 加载地图
    待命 --> 人脸识别: 用户请求
    待命 --> 语音交互: 语音唤醒
    
    建图模式 --> 待命: 保存地图
    
    导航模式 --> 路径规划: 接收目标
    路径规划 --> 导航执行: 规划成功
    路径规划 --> 恢复行为: 规划失败
    恢复行为 --> 路径规划: 重试
    恢复行为 --> 待命: 放弃
    导航执行 --> 待命: 到达目标
    导航执行 --> 恢复行为: 遇到障碍
    
    人脸识别 --> 待命: 识别完成
    
    语音交互 --> 语义解析: IAT识别
    语义解析 --> 导航模式: robot_nav意图
    语义解析 --> 待命: 闲聊回复
    
    待命 --> [*]: 系统关闭
```

---

## 附录：节点清单

### A. 核心节点

| 节点名 | 包名 | 类型 | 功能 |
|-------|-----|------|------|
| `move_base_node` | move_base | C++ | 导航核心 |
| `amcl` | amcl | C++ | 定位 |
| `map_server` | map_server | C++ | 地图服务 |
| `robot_state_publisher` | robot_state_publisher | C++ | TF发布 |

### B. 自定义节点

| 节点名 | 包名 | 类型 | 功能 |
|-------|-----|------|------|
| `camera_node` | face_recognition_pkg | Python | 摄像头 |
| `face_recognition_node` | face_recognition_pkg | Python | 人脸识别 |
| `robot_aiui` | bobac3_audio | C++ | 语音交互 |
| `nav_goal` | nav_goal | C++ | 单点导航 |
| `nav_multigoal` | nav_goal | C++ | 多点巡检 |
| `semanteme` | bobac3_audio | C++ | 语义测试 |

### C. 仿真节点

| 节点名 | 包名 | 类型 | 功能 |
|-------|-----|------|------|
| `gazebo` | gazebo_ros | C++ | 物理仿真 |
| `spawn_model` | gazebo_ros | C++ | 模型加载 |
| `rviz` | rviz | C++ | 可视化 |

---

*图表版本: 1.0*  
*更新日期: 2025-11-28*

> 💡 **提示**: 本文档中的Mermaid图表可在支持Mermaid的Markdown查看器中渲染（如GitHub、VS Code + Mermaid插件、Typora等）。
