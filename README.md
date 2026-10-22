# robot_vechile

面向移动机器人的 ROS 1 工作区，包含 SLAM 建图、地图定位、二维导航、巡检目标发送，以及语音/文本交互相关代码。仓库以 Catkin 多包工作区组织。

> **当前状态（2026-10-22）**：本文档依据仓库源码、launch 文件、参数文件和历史说明整理。此次整理没有运行 Gazebo 或真实机器人测试，因此不把历史说明中的参数变化直接当作已复现的性能提升。仿真入口依赖的 **src/bobac3_description** 当前是没有 **.gitmodules** URL 的 gitlink，干净克隆后无法自动恢复；在补齐该依赖前，不能声称仿真可以开箱运行。

## 项目架构

    传感器 / 里程计 / TF
              |
              v
    SLAM（gmapping / Cartographer / RTAB-Map） ---> 地图 / map_server
                                                      |
                                                      v
    传感器与里程计 --------------------------------> AMCL 定位
                                                      |
                                                      v
    move_base 导航框架：全局规划（如 Navfn）+ 局部规划（TEB / DWA 配置）
                                                      |
                                                      v
                                                 cmd_vel 速度指令

    多点 / 文本导航节点 ---> move_base action
    AIUI 语音服务（听写 / 语义 / 合成） ---> 文本导航节点

| 路径 | 作用 |
|---|---|
| **src/bobac3_navigation/** | Bobac3 平台的地图、AMCL、move_base launch、代价地图与局部规划器参数 |
| **src/bobac3_slam/** | Bobac3 平台的 gmapping、Cartographer、RTAB-Map 等启动配置 |
| **src/oryxbot_navigation/** | Oryxbot 平台的导航配置、地图和 TEB/DWA 参数 |
| **src/oryxbot_slam/** | Oryxbot 平台的 SLAM、前沿探索和 RRT 探索启动配置 |
| **src/nav_goal/** | 单目标、多目标和文本导航客户端 |
| **src/bobac3_audio/** | 语音采集、AIUI、听写/语义/语音合成服务与相关 SDK 文件 |
| **src/bobac3_msgs/** | 项目自定义 ROS 消息/服务定义 |
| **src/robot_bringup/**、**src/robot_control/** | 启动与底层控制相关代码 |
| **param/** | 工作区级参数副本与调参记录；实际生效的文件以 launch 中加载的路径为准 |
| **AIUI/**、**AIUI_backup/** | AIUI 配置、资源及历史备份；第三方许可状态见 [docs/THIRD_PARTY_NOTICES.md](docs/THIRD_PARTY_NOTICES.md) |
| **results/**、**docs/**、**scripts/**、**tests/** | 测试协议、结果登记模板、指标统计脚本和脚本单元测试 |

## 运行环境

从 **src/CMakeLists.txt** 的 Catkin Noetic 路径及仓库中遗留的构建信息判断，目标环境是 **Ubuntu 20.04 + ROS Noetic + Catkin**。这是基于源码和历史构建痕迹的判断，不代表已经在干净机器上完成验证。

建议准备 Ubuntu 20.04 x86-64、ROS Noetic、Catkin、rosdep，以及与所选平台匹配的 Gazebo 模型、URDF、地图和传感器配置。若需语音功能，还要确认 AIUI SDK 版本、授权和运行时依赖。

## 获取与部署

### 1. 克隆仓库

    git clone https://github.com/2543719729/robot_vechile.git
    cd robot_vechile
    source /opt/ros/noetic/setup.bash

### 2. 先恢复缺失的机器人描述包

当前仓库中的 **src/bobac3_description** 是 gitlink，但仓库没有 **.gitmodules** 文件，也没有可用的子模块 URL。**src/bobac3_navigation/launch/demo_nav_2d.launch** 会调用该包中的 **launch/gazebo.launch**。请从原始开发工作区或仓库维护者处恢复该包，并确认来源与许可证；不要猜测一个仓库地址代替它。

### 3. 安装依赖并编译

恢复缺失包后执行：

    sudo apt update
    sudo apt install python3-rosdep python3-catkin-tools
    # 仅首次配置 rosdep 时执行：sudo rosdep init
    rosdep update
    rosdep install --from-paths src --ignore-src -r -y
    catkin_make
    source devel/setup.bash

如果 rosdep 报出无法解析的包，先检查对应 package.xml、ROS 发行版以及未恢复的外部依赖；不要通过删除依赖声明来掩盖问题。

### 4. 仿真导航入口

源码中的仿真导航 launch 为：

    roslaunch bobac3_navigation demo_nav_2d.launch map_file_name:=reicom

该 launch 会组合 Gazebo、地图服务器、仿真版 move_base 和 AMCL。当前因 **bobac3_description** 缺失，命令尚未在干净克隆环境中验证；补齐依赖前预计无法完整启动。地图名称应与 **src/bobac3_navigation/maps/** 下的 YAML 文件及其图像文件对应。

编译后可检查目标程序：

    rosrun nav_goal nav_multigoal_node
    rosrun nav_goal text_nav_node

多目标客户端中的目标坐标是示例值，使用前必须根据实际地图核对坐标、朝向和可通行性。以上命令是源码中声明的可执行目标，不等于已完成导航验收。

## 演示与可验证成果

- 仓库包含 ROS bag 文件，但本次未运行 rosbag info 检查其话题、时长和任务内容，因此暂不将它们标记为可复现的导航演示证据。
- 当前没有可确认的仿真导航视频，也没有带原始日志、固定场景和重复试验记录的巡检成功率或 TEB 前后对照数据。
- 历史文档记录过机器人半径、代价地图膨胀半径等参数变化；它们是参数修改记录，不是经过本次复测的性能结论。
- 复测流程、指标定义和数据登记方式见 [docs/TESTING.md](docs/TESTING.md) 与 [docs/RESULTS.md](docs/RESULTS.md)。统计脚本从实际填写的 CSV 计算指标，不会生成模拟成果数据。

## 个人贡献（按当前仓库内容可核查的范围）

- 整理并维护 ROS 1 Catkin 工作区，集成 SLAM、地图服务、AMCL 和 move_base 导航配置。
- 编写/维护单点、多点及文本导航客户端，基于 move_base action 发送导航目标。
- 配置 TEB、DWA、Navfn 与全局/局部代价地图参数，并保留相关调参说明。
- 集成语音听写、语义理解、语音合成服务的调用链路。

这些描述仅概括仓库中能看到的代码与配置，不代表每个模块都已通过当前环境的端到端验收。若用于简历或项目展示，应进一步补充本人负责的具体文件、提交记录和实测证据。

## 测试

运行不依赖 ROS 的指标脚本单元测试：

    python3 -m unittest discover -s tests -v

ROS 编译、launch 解析、仿真任务和真机任务测试要求见 [docs/TESTING.md](docs/TESTING.md)。

## 许可证与第三方代码

当前仓库没有根目录 LICENSE，多个 ROS 包的 package.xml 仍写有 license TODO。在明确项目自身授权前，不应默认整仓库可以按 MIT、Apache-2.0 或其他许可证重新分发。AIUI SDK、二进制库和 JSONCpp 的来源/许可核查状态见 [docs/THIRD_PARTY_NOTICES.md](docs/THIRD_PARTY_NOTICES.md)。
