#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Optuna 环境测试脚本
测试 Optuna 安装和参数优化流程（不需要ROS）
"""

import os
import sys
import time
import math
import random
import numpy as np
from pathlib import Path
from datetime import datetime

print("=" * 60)
print("Optuna TPE 导航参数优化器 - 环境测试")
print("=" * 60)

# 测试1: 导入依赖
print("\n[1/5] 测试依赖导入...")
try:
    import optuna
    from optuna.samplers import TPESampler
    print(f"  ✓ Optuna {optuna.__version__}")
except ImportError as e:
    print(f"  ✗ Optuna 导入失败: {e}")
    sys.exit(1)

try:
    import yaml
    print(f"  ✓ PyYAML")
except ImportError as e:
    print(f"  ✗ PyYAML 导入失败: {e}")

try:
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt
    print(f"  ✓ Matplotlib {matplotlib.__version__}")
    HAS_MATPLOTLIB = True
except ImportError as e:
    print(f"  ⚠ Matplotlib 不可用 (可选): {e}")
    HAS_MATPLOTLIB = False

try:
    import numpy as np
    print(f"  ✓ NumPy {np.__version__}")
except ImportError as e:
    print(f"  ✗ NumPy 导入失败: {e}")

# 测试2: 读取配置文件
print("\n[2/5] 测试配置文件...")
config_file = Path(__file__).parent / "optuna_config.yaml"
if config_file.exists():
    with open(config_file, 'r') as f:
        config = yaml.safe_load(f)
    print(f"  ✓ 配置文件加载成功")
    print(f"    - 优化次数: {config['optimization']['n_trials']}")
    print(f"    - 测试场景数: {len(config['test_scenarios'])}")
    print(f"\n  语音导航目标点 (来自 voice_nav.cpp):")
    for i, s in enumerate(config['test_scenarios']):
        goal = s['goal']
        print(f"    {i+1}. {s['name']}: ({goal[0]:.3f}, {goal[1]:.3f}) [{s['type']}]")
else:
    print(f"  ⚠ 配置文件不存在: {config_file}")
    config = None

# 测试3: 模拟导航性能评估函数
print("\n[3/5] 测试模拟优化流程...")

def simulate_navigation(params):
    """
    模拟导航性能评估
    真实场景中这会控制机器人运动并收集数据
    这里用数学模型模拟
    """
    # 模拟：参数影响性能的简化模型
    
    # 速度过高会导致不稳定
    vel_penalty = max(0, (params['max_vel_x'] - 0.4) * 2) ** 2
    
    # 膨胀半径太小会碰撞，太大会堵住
    inflation_score = 1.0 - abs(params['inflation_radius'] - 0.15) * 5
    
    # 目标容差影响精度
    precision_score = 1.0 - params['xy_goal_tolerance'] * 5
    
    # 路径权重平衡
    bias_balance = 1.0 - abs(params['path_distance_bias'] - params['goal_distance_bias']) / 50
    
    # 综合得分 (加入随机性模拟真实环境噪声)
    score = (
        0.3 * (1.0 - vel_penalty) +
        0.25 * inflation_score +
        0.25 * precision_score +
        0.2 * bias_balance +
        random.gauss(0, 0.05)  # 噪声
    )
    
    return max(0, min(1, score))

def objective(trial):
    """Optuna 目标函数"""
    params = {
        'max_vel_x': trial.suggest_float('max_vel_x', 0.2, 0.6),
        'max_vel_y': trial.suggest_float('max_vel_y', 0.2, 0.5),
        'inflation_radius': trial.suggest_float('inflation_radius', 0.05, 0.3),
        'xy_goal_tolerance': trial.suggest_float('xy_goal_tolerance', 0.01, 0.1),
        'path_distance_bias': trial.suggest_float('path_distance_bias', 10.0, 40.0),
        'goal_distance_bias': trial.suggest_float('goal_distance_bias', 15.0, 50.0),
    }
    
    # 模拟多个场景的测试
    scores = []
    for _ in range(3):  # 3个场景
        score = simulate_navigation(params)
        scores.append(score)
    
    return np.mean(scores)

# 创建 study 并运行少量试验
print("  运行 10 次模拟优化试验...")
sampler = TPESampler(n_startup_trials=5, seed=42)
study = optuna.create_study(
    direction="maximize",
    sampler=sampler,
    study_name="test_study"
)

# 禁用 optuna 日志
optuna.logging.set_verbosity(optuna.logging.WARNING)

study.optimize(objective, n_trials=10, show_progress_bar=True)

print(f"  ✓ 优化完成")
print(f"    - 最佳得分: {study.best_value:.4f}")
print(f"    - 最佳参数:")
for key, value in study.best_params.items():
    print(f"      {key}: {value:.4f}")

# 测试4: 创建结果目录
print("\n[4/5] 测试结果保存...")
result_dir = Path("/home/liyaxin075/Documents/robot_learning/optuna_results")
result_dir.mkdir(exist_ok=True)

# 保存测试结果
test_result_file = result_dir / "test_result.yaml"
with open(test_result_file, 'w') as f:
    yaml.dump({
        'test_time': datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        'best_score': float(study.best_value),
        'best_params': {k: float(v) for k, v in study.best_params.items()},
        'n_trials': len(study.trials)
    }, f, default_flow_style=False)
print(f"  ✓ 测试结果已保存: {test_result_file}")

# 测试5: 可视化
print("\n[5/5] 测试可视化...")
if HAS_MATPLOTLIB:
    fig, axes = plt.subplots(2, 2, figsize=(12, 10))
    
    # 1. 优化历史
    ax1 = axes[0, 0]
    trials = [t.number for t in study.trials]
    values = [t.value for t in study.trials]
    best_values = []
    current_best = -float('inf')
    for v in values:
        current_best = max(current_best, v)
        best_values.append(current_best)
    
    ax1.plot(trials, values, 'b.-', alpha=0.5, label='Trial Score')
    ax1.plot(trials, best_values, 'r-', linewidth=2, label='Best Score')
    ax1.set_xlabel('Trial')
    ax1.set_ylabel('Score')
    ax1.set_title('Optimization History')
    ax1.legend()
    ax1.grid(True, alpha=0.3)
    
    # 2. 参数分布
    ax2 = axes[0, 1]
    param_names = list(study.best_params.keys())
    param_values = []
    for name in param_names:
        vals = [t.params[name] for t in study.trials]
        param_values.append(vals)
    
    ax2.boxplot(param_values, labels=[n.replace('_', '\n') for n in param_names])
    ax2.set_title('Parameter Distribution')
    ax2.tick_params(axis='x', rotation=45)
    
    # 3. 得分分布
    ax3 = axes[1, 0]
    ax3.hist(values, bins=10, edgecolor='black', alpha=0.7)
    ax3.axvline(x=study.best_value, color='r', linestyle='--', 
                label=f'Best: {study.best_value:.3f}')
    ax3.set_xlabel('Score')
    ax3.set_ylabel('Count')
    ax3.set_title('Score Distribution')
    ax3.legend()
    
    # 4. 参数重要性 (简化版)
    ax4 = axes[1, 1]
    correlations = {}
    for name in param_names:
        vals = [t.params[name] for t in study.trials]
        corr = np.corrcoef(vals, values)[0, 1]
        if not np.isnan(corr):
            correlations[name] = corr
    
    names = list(correlations.keys())
    corrs = list(correlations.values())
    colors = ['green' if c > 0 else 'red' for c in corrs]
    
    bars = ax4.barh(names, corrs, color=colors, alpha=0.7)
    ax4.axvline(x=0, color='black', linewidth=0.5)
    ax4.set_xlabel('Correlation with Score')
    ax4.set_title('Parameter Importance')
    ax4.set_xlim(-1, 1)
    
    plt.tight_layout()
    
    # 保存图表
    plot_file = result_dir / "test_optimization_plot.png"
    plt.savefig(plot_file, dpi=150, bbox_inches='tight')
    print(f"  ✓ 可视化图表已保存: {plot_file}")
    plt.close()
    
    # 尝试显示图表 (如果有GUI)
    try:
        # 使用系统默认程序打开图片
        import subprocess
        subprocess.run(['xdg-open', str(plot_file)], 
                      stdout=subprocess.DEVNULL, 
                      stderr=subprocess.DEVNULL)
        print(f"  ✓ 已打开图表查看器")
    except:
        print(f"  ℹ 请手动打开查看: {plot_file}")
else:
    print("  ⚠ Matplotlib 不可用，跳过可视化")

# 总结
print("\n" + "=" * 60)
print("测试完成!")
print("=" * 60)
print(f"""
环境状态:
  ✓ Optuna TPE 算法工作正常
  ✓ 参数搜索空间定义正确
  ✓ 优化流程可以运行
  ✓ 结果保存功能正常
  {'✓' if HAS_MATPLOTLIB else '⚠'} 可视化{'正常' if HAS_MATPLOTLIB else '需要matplotlib'}

下一步:
  1. 启动仿真环境: roslaunch <your_package> simulation.launch
  2. 启动导航: roslaunch bobac3_navigation move_base.launch  
  3. 根据你的地图修改 optuna_config.yaml 中的目标点
  4. 运行优化器: ./run_optuna_optimizer.sh

结果目录: {result_dir}
""")
