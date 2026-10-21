# 已发布成果与证据范围

## 证据来源

本次检查基于原始提交 `d5d19750f362dd5f7eb48ef47e431bdf5e6b0cf4` 中已有的两份 ROS1 bag。没有新增机器人/仿真采样，没有补写不存在的目标结果，没有生成虚构成功率。

| 文件 | SHA-256 | 记录时长 | 消息数 |
|---|---|---:|---:|
| `2025-11-26-20-20-02.bag` | `6c3707e682c29e53c11b6c63f9911b654169e0396c4ccf4d21101b2fa5f2d8ec` | 67.442 秒 | 5,128 |
| `src/bobac3_slam/bobac3_gazebo_macth.bag` | `8149268753cca03f0bcd61ced83622d92f3281db6731a1c58e9f7e29070b8cb0` | 86.900 秒 | 13,838 |

时长来自消息记录时间跨度，而不是测试日期或 CPU 运行时间。文件名中的日期/`gazebo` 不能单独证明采集环境；原始版本、机器人模型、测试者与条件仍缺少配套清单。

## 实际读取的结果

第二份 bag 有 1,704 条 `/odom`、1,738 条 `/scan` 和 8,691 条 `/imu`。按连续 `/odom` 平面位置的欧氏距离求和，得到 **13.894689197 米**；`twist.linear.x/y` 的平面速度模最大为 **0.398631743 米/秒**。这些数值来自记录中的里程计估计，包含其噪声与漂移，不代表真实路程或外部定位精度。

[轨迹图](media/historical_odometry.png) 和 [MP4 回放](media/historical_odometry.mp4) 使用原始采样时间，默认 4 倍速。绘制脚本没有运行路径规划器，也没有补间生成新的机器人运动。

第一份 bag 中 `/cmd_vel` 的 `linear.x`、`linear.y` 全部为 0，`angular.z` 范围为 0–1 弧度/秒；这份记录更适合命令/旋转诊断，不足以证明平移导航完成。两份 bag 均不包含导航 Action 的 `/goal`、`/result`，也没有巡检轮次定义。

完整话题清单及数量见 [historical_bags.json](../benchmarks/results/historical_bags.json)。

## 尚不能发布的指标

| 指标 | 当前状态 | 缺少的数据 |
|---|---|---|
| 多点巡检成功率 | 未测定，值为 `null` | 独立试次、完整路线、Action 结果、超时记录、定位误差 |
| TEB 调参前后性能差异 | 未测定，值为 `null` | 同条件的成对试次、运行时参数快照、起点/地图/硬件记录 |
| 无碰撞率 | 未测定，值为 `null` | Gazebo 接触传感器或独立实机碰撞检测 |
| 到达精度、真值轨迹误差 | 未测定 | 目标点记录、外部真值或明确的定位误差口径 |

历史文档中的“50 cm → 27 cm、提升 46%”没有实测证据，已撤回。参数变化本身不是性能测量，目标容差也不是最终实测精度。

## 如何复算

在仓库根目录、Python 3.10+ 环境中：

```bash
python -m pip install -r requirements-audit.txt
python scripts/audit_bags.py --check
python scripts/render_bag_replay.py
```

`--check` 会重新读取两份 bag、检查消息数量和 SHA-256，并比较已发布 JSON。视频依赖 FFmpeg；图表不依赖 ROS/Gazebo。视频编码字节可能随 FFmpeg 版本变化，验证以原始数据哈希和 JSON 测量结果为准。

新实验按 [TESTING.md](TESTING.md) 采集后，才能将待测指标替换为实际结果。
