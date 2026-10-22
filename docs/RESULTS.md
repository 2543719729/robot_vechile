# 实验结果与证据清单

## 当前可核查状态

截至 2026-10-22，本次工作只检查了仓库中的源码、launch、参数、历史 Markdown 和 Git 树；没有可用的 ROS/Gazebo 运行环境，也没有在本次修改中执行机器人任务。因此，本页不报告新的导航成功率、耗时改善百分比或避障性能结论。

| 项目 | 仓库证据 | 当前结论 |
|---|---|---|
| 仿真入口 | src/bobac3_navigation/launch/demo_nav_2d.launch、move_base_sim.launch | 已找到启动配置；依赖缺失的 bobac3_description，尚未验证能完整启动 |
| 局部规划器 | 仿真 launch 加载 param/sim/teb_local_planner_params.yaml | 可确认仿真 launch 配置了 TEB 参数；不能据此断言导航效果 |
| 巡检客户端 | src/nav_goal/src/nav_multigoal.cpp | 源码包含两个示例目标和两轮循环；目标坐标写死，未作为实际成功率证据 |
| 录制数据 | 根目录 2025-11-26-20-20-02.bag；src/bobac3_slam/bobac3_gazebo_macth.bag | 文件存在；尚未用 rosbag info 检查 topic、时长和是否覆盖导航任务 |
| 演示视频 | 仓库树中未发现可确认的导航演示视频 | 当前没有可引用的视频证据 |
| 任务成功率 / TEB 对照 | 未发现有可追溯原始日志的 baseline/tuned 试验表 | 不报告数值；请按 TESTING.md 采集后再更新 |

## 历史参数记录（不是本次复测结果）

导航参数优化说明.md 与 WORKSPACE_FIX_REPORT.md 中记录过以下变化：

| 参数 | 历史记录的原值 | 历史记录的调整值 | 证据状态 |
|---|---:|---:|---|
| robot_radius | 0.19 m | 0.15 m | 文档记录，缺少实际机器人尺寸测量与复测日志 |
| 全局 inflation_radius | 0.30 m | 0.12 m | 文档记录，缺少固定场景的对照实验 |
| 局部 inflation_radius | 0.19 m | 0.12 m | 文档记录，缺少固定场景的对照实验 |
| “最小通过间隙” | 约 0.50 m | 约 0.27 m | 旧文档声称的数值；未说明测量方法、地图/footprint、样本数或原始记录，不应作为已验证性能提升引用 |

特别注意：robot_radius 变小可能导致规划器低估实际占用范围。必须先测量真实机器人 footprint 并保留安全裕度，不能仅为通过狭窄通道而盲目缩小。

## 如何把此页更新为可验证成果

1. 恢复仿真依赖并完成冒烟测试。
2. 固定场景、地图、机器人尺寸、起点/终点和超时规则。
3. 对 baseline 和 tuned 做配对重复试验，并保存成功和失败记录。
4. 将原始记录写入 results/navigation_runs.csv（不要覆盖空模板），用统计脚本生成摘要。
5. 将摘要中的样本数、定义、结果与原始 bag/日志/视频链接写回本页，并保留 commit SHA 和参数快照。
