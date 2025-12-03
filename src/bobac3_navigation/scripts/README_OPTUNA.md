# Optuna TPE 导航参数优化器

使用 Optuna 的 TPE (Tree-structured Parzen Estimator) 算法自动优化 ROS 导航参数。

## 原理

### 黑盒优化
- 将导航系统视为黑盒，只关注输入(参数)和输出(性能指标)
- 通过多次仿真试验，寻找最优参数组合
- 无需理解内部机制，直接根据效果调参

### TPE 算法
- 比随机搜索和网格搜索更高效
- 建立参数-性能的概率模型
- 智能选择下一组试验参数
- 随着试验增加，越来越精准

## 优化指标

1. **时间效率** - 导航完成时间
2. **精度** - 到达目标点的位置误差
3. **稳定性** - 运动过程中的振荡程度
4. **窄通道能力** - 通过狭窄区域的成功率
5. **安全性** - 与障碍物的距离

## 搜索的参数

### DWA 局部规划器
- 速度限制 (max_vel_x, max_vel_y, max_vel_theta)
- 加速度限制 (acc_lim_x, acc_lim_y, acc_lim_theta)
- 目标容差 (xy_goal_tolerance, yaw_goal_tolerance)
- 仿真参数 (sim_time, vx_samples, vtheta_samples)
- 轨迹评分权重 (path_distance_bias, goal_distance_bias, occdist_scale)

### Costmap
- 膨胀半径 (inflation_radius)
- 代价衰减因子 (cost_scaling_factor)
- 障碍物检测范围 (obstacle_range, raytrace_range)

### Move Base
- 控制频率 (controller_frequency)
- 规划频率 (planner_frequency)

## 使用方法

### 1. 安装依赖

```bash
pip3 install -r requirements_optuna.txt
```

### 2. 配置测试场景

编辑 `optuna_config.yaml`，根据你的地图设置目标点：

```yaml
test_scenarios:
  - name: "直线前进"
    goal: [2.0, 0.0, 0.0]  # [x, y, yaw]
    type: normal
    weight: 1.0
```

### 3. 启动仿真环境

```bash
# 启动 Gazebo 仿真
roslaunch your_package simulation.launch

# 启动导航
roslaunch bobac3_navigation move_base.launch
```

### 4. 运行优化器

```bash
# 方式1: 使用启动脚本
./run_optuna_optimizer.sh

# 方式2: 直接运行
rosrun bobac3_navigation optuna_nav_optimizer.py
```

### 5. 查看结果

```bash
# 生成可视化报告
python3 optuna_visualize.py

# 查看结果文件
ls ~/Documents/robot_learning/optuna_results/
```

## 输出文件

优化完成后，在 `optuna_results/` 目录下会生成：

| 文件 | 说明 |
|------|------|
| `best_params_latest.yaml` | 最佳参数配置 |
| `best_params_YYYYMMDD_HHMMSS.yaml` | 带时间戳的最佳参数 |
| `all_trials_YYYYMMDD_HHMMSS.yaml` | 所有试验的详细结果 |
| `optimization_history.csv` | 优化历史数据 |
| `optimization_history.png` | 优化过程图表 |
| `parameter_importance.png` | 参数重要性分析图 |
| `optimization_report.md` | Markdown格式报告 |

## 最佳实践

### 场景设计
1. **多样化**: 包含直线、转弯、窄通道等多种场景
2. **权重分配**: 重要场景设置更高权重
3. **合理目标**: 目标点应在机器人可达范围内

### 参数调整
1. **缩小搜索范围**: 如果对某些参数有经验，可缩小范围加快收敛
2. **增加试验次数**: 复杂问题建议50-100次
3. **分阶段优化**: 先粗调再细调

### 注意事项
1. **仿真稳定性**: 确保仿真环境稳定运行
2. **参数备份**: 脚本会自动备份原参数到 `backup_*/`
3. **中断恢复**: 按 Ctrl+C 安全中断，已有结果会保存

## 示例输出

```
Trial 42/50
==========================================
  测试场景: 直线前进2米
    得分: 0.823 (时间:0.89, 精度:0.95, 稳定:0.72)
  测试场景: 窄通道穿越
    得分: 0.756 (时间:0.65, 精度:0.88, 稳定:0.81)
Trial 42 最终得分: 0.7892 (成功率: 100.0%)
🎉 新的最佳得分: 0.7892
```

## 常见问题

### Q: 优化很慢怎么办？
A: 
- 减少测试场景数量
- 缩短单次超时时间
- 减少试验次数（先用20次看效果）

### Q: 得分总是很低？
A:
- 检查目标点是否可达
- 检查仿真环境是否正常
- 适当放宽目标容差

### Q: 如何应用优化结果？
A: 最佳参数会自动写入 `param/sim/` 目录，重启 move_base 即可生效。
