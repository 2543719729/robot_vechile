#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
查询分布式训练的最佳参数
所有Worker的结果都存储在MySQL中，此脚本可查询全局最佳参数
"""

import yaml
import optuna
from pathlib import Path

# 数据库连接
STORAGE_URL = "mysql+pymysql://optuna:optuna123@localhost:3306/optuna_db"
STUDY_NAME = "nav_param_optimization"

def get_best_params():
    """获取全局最佳参数"""
    try:
        study = optuna.load_study(
            study_name=STUDY_NAME,
            storage=STORAGE_URL
        )
    except KeyError:
        print("❌ 未找到Study，请先运行训练")
        return None
    
    # 统计信息
    all_trials = study.trials
    completed = [t for t in all_trials if t.state == optuna.trial.TrialState.COMPLETE]
    failed = [t for t in all_trials if t.state == optuna.trial.TrialState.FAIL]
    pruned = [t for t in all_trials if t.state == optuna.trial.TrialState.PRUNED]
    
    print("=" * 60)
    print("Optuna 分布式训练统计")
    print("=" * 60)
    print(f"总Trials数: {len(all_trials)}")
    print(f"  - 完成: {len(completed)}")
    print(f"  - 失败: {len(failed)}")
    print(f"  - 剪枝: {len(pruned)}")
    print()
    
    if len(completed) == 0:
        print("❌ 没有成功完成的Trial，无法获取最佳参数")
        return None
    
    # 最佳参数
    best_trial = study.best_trial
    print(f"🏆 最佳Trial: #{best_trial.number}")
    print(f"   最佳得分: {best_trial.value:.4f}")
    print()
    print("最佳参数:")
    print("-" * 40)
    for key, value in best_trial.params.items():
        if isinstance(value, float):
            print(f"  {key}: {value:.6f}")
        else:
            print(f"  {key}: {value}")
    
    return best_trial.params

def save_best_params():
    """保存最佳参数到YAML文件"""
    params = get_best_params()
    if params is None:
        return
    
    # 保存路径
    result_dir = Path("/home/liyaxin075/Documents/robot_learning/optuna_results")
    result_dir.mkdir(exist_ok=True)
    
    output_file = result_dir / "best_params_distributed.yaml"
    
    with open(output_file, 'w') as f:
        yaml.dump({
            'best_params': params,
            'source': 'distributed_training',
            'database': STORAGE_URL.split('@')[0] + '@***'
        }, f, default_flow_style=False, allow_unicode=True)
    
    print()
    print(f"✅ 最佳参数已保存到: {output_file}")

def apply_best_params():
    """将最佳参数应用到配置文件"""
    params = get_best_params()
    if params is None:
        return
    
    param_dir = Path("/home/liyaxin075/Documents/robot_learning/src/bobac3_navigation/param/sim")
    
    # 这里可以添加将参数写入各个YAML配置文件的逻辑
    print()
    print("💡 如需应用参数，请运行:")
    print("   python3 get_best_params.py --apply")

def show_top_trials(n=10):
    """显示前N个最佳Trial"""
    try:
        study = optuna.load_study(
            study_name=STUDY_NAME,
            storage=STORAGE_URL
        )
    except KeyError:
        print("❌ 未找到Study")
        return
    
    completed = [t for t in study.trials if t.state == optuna.trial.TrialState.COMPLETE]
    sorted_trials = sorted(completed, key=lambda t: t.value if t.value else -999, reverse=True)
    
    print()
    print(f"Top {min(n, len(sorted_trials))} Trials:")
    print("-" * 40)
    for i, trial in enumerate(sorted_trials[:n]):
        print(f"  #{trial.number}: 得分={trial.value:.4f}")

if __name__ == '__main__':
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == '--apply':
        apply_best_params()
    else:
        save_best_params()
        show_top_trials()
