# 测试与复现实验流程

本文把代码检查、仿真验收和性能对比分开。通过单元测试不等于导航可用；launch 能启动也不等于任务成功率达标。

## 1. 代码与工作区检查

在 Ubuntu 20.04 + ROS Noetic 环境中，先恢复 src/bobac3_description，再执行：

    source /opt/ros/noetic/setup.bash
    rosdep install --from-paths src --ignore-src -r -y
    catkin_make
    source devel/setup.bash
    python3 -m unittest discover -s tests -v

可选的 XML 语法检查：

    find src -name '*.launch' -type f -print0 | xargs -0 -n1 xmllint --noout

xmllint 只能检查 XML 语法，不能验证 ROS 包名、参数加载路径、topic/TF 连通性或 Gazebo 资源是否存在。

## 2. 仿真冒烟测试

1. 记录仓库 commit SHA、ROS 发行版、Gazebo 版本、地图 YAML/图像文件 SHA、机器人描述版本和参数文件 SHA。
2. 启动仿真导航：

       roslaunch bobac3_navigation demo_nav_2d.launch map_file_name:=reicom

3. 确认 Gazebo 模型加载、/map 发布、TF 树连通、/scan 与 /odom 持续更新、AMCL 位姿合理、move_base action server 可用。
4. 先执行单个安全目标，再执行多目标巡检。每次试验保存终端日志、RViz/仿真视频和 rosbag；失败试验也必须保留。
5. 若 launch 因缺失 bobac3_description 或其他资源失败，记录为环境阻塞，不要记为算法失败或成功。

建议检查命令：

    rostopic list
    rostopic hz /scan
    rostopic hz /odom
    rosrun tf view_frames
    rosbag record -O results/<run_id>.bag /tf /tf_static /odom /scan /cmd_vel /move_base/status /move_base/feedback /move_base/result

实际 topic 名称可能因平台配置而异；录制前用 rostopic list 确认。结束后对每个 bag 执行 rosbag info results/<run_id>.bag 并把输出随实验记录保存。

## 3. TEB 调参前后对比

### 控制变量

- 使用相同地图、机器人模型/footprint、起始位姿、目标点序列、速度/加速度限制和超时规则。
- baseline 与 tuned 使用同一场景与相同 seed/重复编号；每组都必须包含失败试验。
- 建议至少选 3 种拓扑场景（开阔区、狭窄通道、直角转弯/障碍绕行），每个场景每个配置至少 20 次重复。若资源不足，报告真实样本量，不要把建议值写成已完成实验。
- 除 TEB 参数外，不要同时改变地图、footprint、传感器噪声和恢复策略；若确实修改，单独标注为另一组实验。

### 每次运行需要记录

填写 [../results/navigation_runs_template.csv](../results/navigation_runs_template.csv) 中的字段，并保存原始 rosbag/日志、视频、配置快照和 commit SHA。scene_id + seed 应在 baseline/tuned 之间一一配对；同一配置下不能重复使用同一个组合。

| 指标 | 定义 |
|---|---|
| 任务成功率 | 全部目标到达且记录碰撞数为 0 的任务数 / 任务总数 |
| 航点成功率 | 实际到达的航点总数 / 计划航点总数 |
| 成功任务耗时 | 仅对成功任务统计，从任务开始到最后一个目标到达 |
| 成功任务路径长度 | 仅对成功任务统计，采用同一种轨迹积分方法 |
| 碰撞次数 | 使用一致的 Gazebo contact/碰撞判据或人工审核记录 |
| 恢复次数 | move_base 恢复行为触发次数；应从日志或状态记录提取 |
| 最小障碍间隙 | 采用一致的 footprint 与障碍物几何定义计算；未知时留空，不要猜值 |

### 统计

    python3 scripts/evaluate_navigation_runs.py results/navigation_runs.csv

脚本输出各配置的成功率、航点成功率、成功任务耗时/路径长度、碰撞/恢复统计，以及同一 scene_id 和 seed 下 baseline/tuned 的配对差值。它只计算 CSV 中的数据；结果仍需与 rosbag、视频和日志交叉核验。

## 4. 视频与结果归档

推荐每次运行至少保存：

    results/<run_id>/
    ├── metadata.txt        # commit、ROS/Gazebo 版本、地图/参数 SHA、起终点
    ├── rosbag-info.txt     # rosbag info 输出
    ├── run.log             # 终端与导航状态日志
    ├── demo.mp4            # 同一视角录屏，失败也保留
    └── params/             # baseline 或 tuned 的实际加载参数快照

提交到 Git 的视频和 bag 应控制体积并确认数据授权。可用 GitHub Release、外部对象存储或仓库 LFS 保存大文件，但 README 必须提供可访问链接及其对应的实验 ID。
