# 导航策略优化报告

## 调研结论

经过全面调研，针对"机器人无法精确到达目标点且受障碍物干扰"的问题，建议采取以下策略：

---

## 推荐方案：切换到TEB局部规划器

### 理由
1. **DWA的固有缺陷**：
   - 采样式优化，控制动作在预测期间恒定
   - 无法规划倒车或复杂绕障动作
   - 容易陷入局部最优

2. **TEB的优势**：
   - 支持倒车和复杂机动
   - 多拓扑路径规划（可以规划障碍物左右两侧的路径）
   - 连续优化，轨迹更接近最优解
   - 支持动态障碍物避让

---

## 配置修改建议

### 1. 修改 move_base_params.yaml

```yaml
# 切换局部规划器
base_local_planner: "teb_local_planner/TebLocalPlannerROS"

# 增加控制器耐心
controller_patience: 15.0
planner_patience: 10.0

# 增加振荡容忍度
oscillation_timeout: 15.0
oscillation_distance: 0.15

# 完善恢复行为
recovery_behavior_enabled: true
recovery_behaviors:
  - name: 'clear_costmap'
    type: 'clear_costmap_recovery/ClearCostmapRecovery'
  - name: 'rotate_recovery'
    type: 'rotate_recovery/RotateRecovery'
  - name: 'aggressive_clear'
    type: 'clear_costmap_recovery/ClearCostmapRecovery'

clear_costmap:
  reset_distance: 2.0
aggressive_clear:
  reset_distance: 0.0
```

### 2. 优化 teb_local_planner_params.yaml

```yaml
TebLocalPlannerROS:
  # === 目标精度优化 ===
  xy_goal_tolerance: 0.03          # 3cm位置精度
  yaw_goal_tolerance: 0.05         # ~3°角度精度
  free_goal_vel: False             # 到达目标时停止

  # === 全局路径跟随增强 ===
  global_plan_viapoint_sep: 0.3    # 更密集的路径点
  weight_viapoint: 5.0             # 增加路径跟随权重
  max_global_plan_lookahead_dist: 3.0  # 增加前瞻距离

  # === 障碍物处理优化 ===
  min_obstacle_dist: 0.15          # 适当安全距离
  inflation_dist: 0.2              # 膨胀距离
  weight_obstacle: 100             # 增加障碍物惩罚权重
  obstacle_poses_affected: 20      # 增加受影响的位姿数

  # === 优化迭代 ===
  no_inner_iterations: 6           # 增加内部迭代
  no_outer_iterations: 5           # 增加外部迭代

  # === 振荡恢复 ===
  oscillation_recovery: True
  shrink_horizon_backup: True
  shrink_horizon_min_duration: 8
```

### 3. 优化 local_costmap_params.yaml

```yaml
local_costmap:
   width: 3.0                      # 扩大视野
   height: 3.0
   resolution: 0.05
   update_frequency: 10.0          # 更快更新
   publish_frequency: 5.0
   
   inflation_layer:
      enabled: true
      cost_scaling_factor: 3.0     # 降低衰减速度（更平滑的代价梯度）
      inflation_radius: 0.25       # 适当增加膨胀半径
```

### 4. 优化 global_costmap_params.yaml

```yaml
global_costmap:
   update_frequency: 2.0
   publish_frequency: 1.0
   
   inflation_layer:
      enabled: true
      cost_scaling_factor: 3.0
      inflation_radius: 0.30
```

---

## 关键参数解释

### 目标容差 vs 膨胀半径

**重要原则**：`xy_goal_tolerance` 必须大于 `inflation_radius`

否则目标点可能落在膨胀区内，被认为不可达。

当前问题：
- `xy_goal_tolerance: 0.02` < `inflation_radius: 0.10` ❌

修复后：
- `xy_goal_tolerance: 0.03` < `inflation_radius: 0.25` 
- 但实际目标精度由规划器能力决定，TEB可以更好地处理

### cost_scaling_factor

- 高值（5.0）：代价快速衰减，机器人更敢接近障碍物
- 低值（2.0）：代价缓慢衰减，机器人更保守

建议从3.0开始调试。

---

## 备选方案

### 方案B：双阶段导航

1. **粗导航**：使用move_base导航到目标附近（0.3m内）
2. **精导航**：切换到自定义PID控制器精确对准

适用于：需要毫米级精度的场景

### 方案C：升级到ROS2 Nav2

Nav2提供更现代的导航栈：
- MPPI控制器：基于模型预测路径积分，智能行为
- Regulated Pure Pursuit：精确路径跟踪
- 更好的行为树框架

---

## 测试建议

1. 先在仿真环境测试TEB配置
2. 逐步调整参数：
   - 先调整 `weight_obstacle` 确保避障
   - 再调整 `weight_viapoint` 确保路径跟随
   - 最后调整 `xy_goal_tolerance` 和 `yaw_goal_tolerance`

3. 观察rviz中的轨迹可视化：
   - 绿色路径：全局规划
   - 红色路径：TEB局部轨迹
   - 确保局部轨迹能绑到目标点

---

## 参考资源

- TEB Local Planner Wiki: http://wiki.ros.org/teb_local_planner
- TEB Tutorials: http://wiki.ros.org/teb_local_planner/Tutorials
- Nav2 Tuning Guide: https://docs.nav2.org/tuning/index.html
- ROS Navigation Tuning Guide: https://arxiv.org/pdf/1706.09068
