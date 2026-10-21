# 环境、依赖与部署边界

## 当前可复现范围

离线审计可在 Python 3.10+ 独立运行。ROS 工程的历史复现目标是 Ubuntu 20.04 / ROS Noetic / Gazebo Classic 11；本次工作环境没有 `roscore`、`roslaunch`、Gazebo 或 Docker，因此没有宣称完成 C++ 构建、在线定位或仿真导航。

## 外部资源清单

| 资源 | 用途 | 仓库内是否提供 | 获取与验证 |
|---|---|---|---|
| `bobac3_description` | URDF、Gazebo 启动、机器人插件 | 否 | 向原始实验环境/厂商取得匹配包；`rospack find bobac3_description` |
| 与机器人匹配的 Gazebo 世界/模型 | 原工程导航场景 | 否 | 旧报告提到 `reinovo_robocom`；名称是线索，不能据此确认版本或授权 |
| ROS Navigation / AMCL / Navfn / map_server | 导航基础模块 | 作为系统依赖安装 | `ros-noetic-navigation` |
| TEB | 仿真局部规划器 | 作为系统依赖安装 | `ros-noetic-teb-local-planner` |
| Gazebo ROS | 仿真桥接 | 作为系统依赖安装 | `ros-noetic-gazebo-ros-pkgs` |
| `rei_robot_base`、`rei_ydlidar_nodelet` | 实机底盘与激光驱动 | 否 | 只在实机链路使用，由对应厂商提供 |
| GMapping / Cartographer / RTAB-Map 等 | 不同建图入口 | 未完整提供 | 按具体 launch 单独安装；不承诺全部入口已验证 |
| AIUI SDK 和配置 | 可选语音 | 有头文件、资源及 x86-64 `.so`；缺明确授权文件 | 从 [AIUI 官方平台](https://aiui.xfyun.cn/) 核对版本、账号权限和许可 |

厂商来源线索是 [深圳元创兴科技 / reinovo](https://gitee.com/reinovo) 的相关项目，例如 [oryxbot_ws](https://gitee.com/reinovo/oryxbot_ws)。**这只是核查入口，不是已确认匹配的 bobac3 模型下载地址。** 不要直接混入另一平台的描述包，否则 TF、控制插件和场景可能不匹配。

## 导航主线构建

先 source Noetic 及包含厂商包的 underlay，再按 README 使用白名单构建。白名单避免把不相关的历史实验包和语音 SDK 一起纳入构建；它不会自动补齐机器人模型。

```bash
source /opt/ros/noetic/setup.bash
python3 scripts/check_workspace.py --runtime
catkin_make -DCATKIN_WHITELIST_PACKAGES="bobac3_navigation;nav_goal" -DNAV_GOAL_WITH_AUDIO=OFF
source devel/setup.bash
```

若模型放在本工作空间且需要编译，应将其及依赖包加入白名单，或先单独构建 underlay。`rospack find` 只证明能找到包，不证明插件、世界文件和资源完整。

## 可选语音构建

确认 SDK 的使用/分发权限、架构和有效 AIUI 配置后：

```bash
sudo apt install libasound2-dev
catkin_make -DCATKIN_WHITELIST_PACKAGES="bobac3_msgs;bobac3_audio" -DNAV_GOAL_WITH_AUDIO=OFF
source devel/setup.bash
catkin_make -DCATKIN_WHITELIST_PACKAGES="bobac3_msgs;bobac3_audio;bobac3_navigation;nav_goal" -DNAV_GOAL_WITH_AUDIO=ON
source devel/setup.bash
rosrun bobac3_audio voice_aiui_node
```

另一个终端：

```bash
rosrun nav_goal text_nav_node _enable_tts:=true
```

本次已把生成的服务头文件与 C++ 类型统一为包实际名称 `bobac3_audio`，并补充消息依赖；不再依赖已删除的 `devel/robot_audio` 旧残留。`include/robot_audio/aiui` 是原 SDK 的目录名，与生成服务的命名空间不是一回事，因此保留。

AIUI 的资源加载使用工作目录相关路径。按原工程从仓库根目录运行节点，并检查 `AIUI/`；构建脚本另外复制一份到 `~/.ros/AIUI`。账号配置和云服务未在本次验证，不要将默认文本导航视作语音服务测试。

## 清理与重建

本次从 Git 跟踪中移除了 `build/`、`devel/`、AIUI 运行日志/缓存、合成语音临时文件及 `AIUI_backup/`。保留原始 bag、地图、唤醒音频、SDK 资源和运行库。清理统计见 [cleanup.json](../benchmarks/results/cleanup.json)。

未重写 Git 历史，所以旧提交仍包含这些生成文件；后续克隆的历史体积不会因此等比例缩小。重新构建时本地产生的输出会由 `.gitignore` 排除。
