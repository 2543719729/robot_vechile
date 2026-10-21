# 测试流程与指标口径

## 1. 离线检查：现在即可运行

使用 Python 3.10+，从仓库根目录执行：

```bash
python -m pip install -r requirements-audit.txt
python scripts/check_workspace.py
python -m unittest discover -s tests -v
python scripts/audit_bags.py --check
```

静态检查覆盖生成文件清理、61 份包清单/launch XML 语法、17 张地图的相对路径、catkin 入口、服务命名空间和主线参数 YAML 语法。单元测试使用明确标为 synthetic 的临时内存数据，检查统计错误、数据缺失和超时处理；**这些测试不是机器人实验成果**。

`audit_bags.py --check` 实际读取仓库的两份历史 bag 并复算 [已发布证据](RESULTS.md)。Noetic 容器中不依赖语音 SDK 的三个 `nav_goal` 客户端已实际编译通过，离线检查亦通过：[CI 运行记录](https://github.com/2543719729/robot_vechile/actions/runs/39634005142)，对应代码提交 `e65215fd6fe791a2b77d523d1a68546e1ec634f4`，机器可读范围见 `benchmarks/results/ci_verification.json`。后续提交状态以各自的 Actions 记录为准。CI 不运行导航任务或 Gazebo，不据此生成导航成功率。

## 2. ROS / Gazebo 冒烟验证

完成 [依赖安装](DEPENDENCIES.md)，退出离线虚拟环境并 source Noetic 与工作空间：

```bash
python3 scripts/check_workspace.py --runtime
roslaunch bobac3_navigation demo_nav_2d.launch map_file_name:=reicom
```

另一个终端检查：

```bash
rosparam get /use_sim_time
rostopic hz /clock
rostopic hz /scan
rostopic hz /odom
rosrun tf tf_echo map base_footprint
rosparam get /move_base_node/base_local_planner
rosparam get /move_base_node/TebLocalPlannerROS
rostopic list
```

通过条件：仿真时间持续前进；扫描、里程计持续更新；TF 链无缺失且激光与地图一致；实际局部规划器为 `teb_local_planner/TebLocalPlannerROS`。`/move_base` 是 Action 名，参数和路径话题属于节点 `/move_base_node`。若使用自定义 namespace，应同时修改下面的记录话题和评测脚本参数。

先用 RViz `2D Pose Estimate` 设定实际起点，再选一个已确认可达的目标。保存控制台日志。单次到达是冒烟测试，不是完整成功率。

## 3. 预先登记新实验条件

仓库提供 `benchmarks/routes/city_patrol.yaml`，坐标直接取自历史文本导航代码，**尚未在当前世界/地图上重新核验**。改变场景时必须重新选择自由空间中的位置，并保存新的路线文件。

`benchmarks/profiles/baseline.yaml` 与 `tuned.yaml` 是两个有来源记录的历史配置候选。二者来自同一个导入提交，不能证明历史调参先后顺序，也不是已经验证过的优劣结论。来源与 SHA-256 见同目录 `manifest.json`。

它们同时改变速度、footprint 近似、权重和容差。新实验若保留这些差异，结论只能归属于**整套配置**；若想研究单一调参效果，另存两份候选配置，统一实际机体尺寸、速度上限及评测容差后再测试。不要缩小真实 footprint 来换取表面成功率。当前历史 costmap 的 `inflation_radius=0.05` 小于 `robot_radius=0.19`，其代价梯度/碰撞效果需要在对应模型上专门验证；本次没有擅自调参或宣称安全通过。

建议先完成 1 对管线验证，再为同一场景预登记至少 20 对试次；这只是实验计划，**不是现有样本量**。失败、超时、中断和异常都应保留，不能只挑成功录像。

每个独立试次应：

1. 重启或复位机器人与世界到同一起点，重置定位并核对 TF；只复位 Gazebo 不重置 AMCL/里程计不算同条件。
2. 使用同一地图、路线、机器人/世界版本、控制硬件、传感器频率和外部障碍设置。
3. 交替或随机安排 baseline/tuned 顺序，预先写好每个 `scenario/trial_id/variant`，保留预登记表和所有尝试。
4. 记录代码提交、世界/模型哈希、机器型号和运行时参数。脚本自动保存参数、地图和路线指纹；`--hardware` 与 `--world-id` 的真实内容由测试者提供。

## 4. 每个试次采集原始证据

以第 1 个 baseline 试次为例，先用所选配置启动仿真：

```bash
roslaunch bobac3_navigation demo_nav_2d.launch map_file_name:=reicom teb_config:=$(pwd)/benchmarks/profiles/baseline.yaml
```

完成初始定位后，启动录制（保留同名的控制台日志和屏幕录像）：

```bash
mkdir -p benchmarks/runs
rosbag record -O benchmarks/runs/city_01_baseline.bag /clock /map /scan /odom /tf /tf_static /cmd_vel /move_base/goal /move_base/result /move_base/status /move_base/cancel /move_base_node/NavfnROS/plan /move_base_node/global_costmap/costmap /move_base_node/local_costmap/costmap
```

在另一个终端发送任务。以下硬件和世界标识应替换成实际型号与版本指纹：

```bash
python3 scripts/run_patrol.py --route benchmarks/routes/city_patrol.yaml --map src/bobac3_navigation/maps/reicom.yaml --scenario city_patrol --trial-id 01 --variant baseline --environment simulation --hardware actual-host-model --world-id actual-world-model-sha256 --output benchmarks/runs/city_01_baseline.json
```

`run_patrol.py` 使用 Noetic 的 `rospy/actionlib/tf` 与 PyYAML，不依赖离线审计环境。它一次运行一条完整路线，保存实际加载的 `/move_base_node` 参数和 `/map` 指纹、起点、逐目标状态及定位偏差。读取服务/话题与执行目标都设有墙钟上限，仿真时钟停止不会无限等待。发生超时或中断会尝试取消当前目标并保留失败记录；运行脚本不能代替底盘自身的停机保护。

结束录制后校验 bag 可读，并将录像、日志和 JSON 放在同一个证据目录。随后彻底复位，再以 `tuned.yaml` 和相同 `trial-id` 运行 tuned 试次，文件名和 `--variant` 同步改为 tuned。若使用别的 Action/节点名，通过 `--action`、`--planner-ns` 指定。

## 5. 指标定义

| 指标 | 计算规则 | 边界 |
|---|---|---|
| 单目标通过 | Action 状态为 SUCCEEDED，未超时，且定位误差满足统一评测阈值 | 默认位置 0.10 米、航向 0.20 弧度；两组相同；不是外部真值精度 |
| 单次巡检成功 | 所有预定目标都通过、过程完整且无执行错误 | 中途失败后未执行的剩余目标不会被偷偷忽略 |
| 巡检成功率 | 成功试次数 / 实际尝试试次数 | 失败/超时/中断计入分母；启动前缺参数/地图的记录不具备比较条件，统计器会拒绝整组输入 |
| 配对耗时差 | 两组均成功的配对中，tuned 耗时减 baseline 耗时 | 使用 ROS 时间；同时记录墙钟时间；失败试次不混入“成功耗时” |
| 配对路程差 | 对合格配对的逐目标 `/odom` 路段长度求和后比较 | 不含目标切换间隙；丢帧超过 0.5 秒、时钟回退、单步跳变超过 1 米或坐标系改变时，路程标为未知 |
| 无碰撞率 | 当前为 `null` | 需要独立接触/碰撞检测；雷达最小距离和 Action 成功均不能替代 |

遇到缺少 `/odom`、TF 或定位误差时，输出未知/失败，不填 0 伪装完整数据。脚本退出码为 0 表示该试次符合巡检成功定义；为 1 时应保留日志及 JSON，排查失败原因。

## 6. 严格配对统计

采集完计划内所有试次后：

```bash
python3 scripts/compare_patrol.py benchmarks/runs/city_*.json --output benchmarks/runs/paired_report.json
```

应在第一次生成汇总前运行该通配符，或将原始试次 JSON 放在独立子目录，避免把上一次汇总当作输入。输出不允许覆盖已有文件。

统计器拒绝重复 ID、缺失配对、地图/路线/硬件/世界/容差不一致，以及起点相差超过 0.05 米或 0.1 弧度的配对。每组参数快照必须固定。报告同时显示分母、成功数、双方均成功的配对数量和缺失路程数量，不会只给一个好看的百分比。检查器不能证明手填元数据真实，也不能代替原始录像和测试者签名。

原始 bag 和运行目录默认不提交 Git；保留其校验和，并在发布说明中给出真实可访问的附件/Release 链接、参数快照、完整试次清单及对应录像。许可不明的厂商模型不要随测试附件重新发布。
