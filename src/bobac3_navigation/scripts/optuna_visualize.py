#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Optuna 优化结果可视化脚本
"""

import os
import yaml
import argparse
from pathlib import Path

try:
    import matplotlib.pyplot as plt
    import matplotlib
    matplotlib.use('Agg')  # 无GUI模式
    HAS_MATPLOTLIB = True
except ImportError:
    HAS_MATPLOTLIB = False
    print("警告: matplotlib 未安装，跳过图表生成")

import numpy as np


def load_results(result_dir):
    """加载优化结果"""
    result_dir = Path(result_dir)
    
    # 查找最新的 all_trials 文件
    trial_files = list(result_dir.glob("all_trials_*.yaml"))
    if not trial_files:
        print("错误: 未找到优化结果文件")
        return None
    
    latest_file = max(trial_files, key=lambda x: x.stat().st_mtime)
    print(f"加载结果文件: {latest_file}")
    
    with open(latest_file, 'r') as f:
        results = yaml.safe_load(f)
    
    return results


def load_best_params(result_dir):
    """加载最佳参数"""
    result_dir = Path(result_dir)
    best_file = result_dir / "best_params_latest.yaml"
    
    if not best_file.exists():
        return None
    
    with open(best_file, 'r') as f:
        return yaml.safe_load(f)


def print_summary(results, best_params):
    """打印优化摘要"""
    print("\n" + "=" * 60)
    print("优化结果摘要")
    print("=" * 60)
    
    if not results:
        print("无结果数据")
        return
    
    # 基本统计
    scores = [r['score'] for r in results]
    success_rates = [r['success_rate'] for r in results]
    
    print(f"\n总试验次数: {len(results)}")
    print(f"得分范围: {min(scores):.4f} - {max(scores):.4f}")
    print(f"平均得分: {np.mean(scores):.4f} ± {np.std(scores):.4f}")
    print(f"平均成功率: {np.mean(success_rates)*100:.1f}%")
    
    # 最佳结果
    if best_params:
        print(f"\n最佳得分: {best_params['score']:.4f}")
        print(f"获得时间: {best_params.get('timestamp', 'N/A')}")
        
        print("\n最佳参数:")
        print("-" * 40)
        for key, value in sorted(best_params['params'].items()):
            if isinstance(value, float):
                print(f"  {key}: {value:.4f}")
            else:
                print(f"  {key}: {value}")
    
    # 收敛分析
    print("\n收敛分析:")
    print("-" * 40)
    
    # 分段统计
    n = len(scores)
    if n >= 10:
        first_10 = np.mean(scores[:10])
        last_10 = np.mean(scores[-10:])
        improvement = (last_10 - first_10) / max(first_10, 0.001) * 100
        print(f"  前10次平均: {first_10:.4f}")
        print(f"  后10次平均: {last_10:.4f}")
        print(f"  提升幅度: {improvement:+.1f}%")
    
    # 找出得分提升的关键参数
    if best_params and len(results) > 5:
        print("\n关键参数分析:")
        print("-" * 40)
        
        # 按得分排序
        sorted_results = sorted(results, key=lambda x: x['score'], reverse=True)
        top_5 = sorted_results[:5]
        bottom_5 = sorted_results[-5:]
        
        # 分析参数差异
        param_keys = list(top_5[0]['params'].keys())
        for key in param_keys:
            top_vals = [r['params'][key] for r in top_5]
            bottom_vals = [r['params'][key] for r in bottom_5]
            
            if isinstance(top_vals[0], (int, float)):
                top_mean = np.mean(top_vals)
                bottom_mean = np.mean(bottom_vals)
                diff_pct = abs(top_mean - bottom_mean) / max(abs(bottom_mean), 0.001) * 100
                
                if diff_pct > 20:  # 差异超过20%才显示
                    print(f"  {key}:")
                    print(f"    优秀组平均: {top_mean:.4f}")
                    print(f"    较差组平均: {bottom_mean:.4f}")


def plot_optimization_history(results, output_dir):
    """绘制优化历史图"""
    if not HAS_MATPLOTLIB:
        return
    
    output_dir = Path(output_dir)
    
    trials = [r['trial'] for r in results]
    scores = [r['score'] for r in results]
    success_rates = [r['success_rate'] for r in results]
    
    # 计算累积最佳
    best_scores = []
    current_best = -float('inf')
    for s in scores:
        current_best = max(current_best, s)
        best_scores.append(current_best)
    
    fig, axes = plt.subplots(2, 2, figsize=(14, 10))
    
    # 1. 得分历史
    ax1 = axes[0, 0]
    ax1.plot(trials, scores, 'b-', alpha=0.5, label='Trial Score')
    ax1.plot(trials, best_scores, 'r-', linewidth=2, label='Best Score')
    ax1.set_xlabel('Trial')
    ax1.set_ylabel('Score')
    ax1.set_title('Optimization History')
    ax1.legend()
    ax1.grid(True, alpha=0.3)
    
    # 2. 成功率历史
    ax2 = axes[0, 1]
    ax2.plot(trials, [sr * 100 for sr in success_rates], 'g-', alpha=0.7)
    ax2.axhline(y=np.mean(success_rates)*100, color='r', linestyle='--', label='Average')
    ax2.set_xlabel('Trial')
    ax2.set_ylabel('Success Rate (%)')
    ax2.set_title('Navigation Success Rate')
    ax2.legend()
    ax2.grid(True, alpha=0.3)
    
    # 3. 得分分布
    ax3 = axes[1, 0]
    ax3.hist(scores, bins=20, edgecolor='black', alpha=0.7)
    ax3.axvline(x=np.mean(scores), color='r', linestyle='--', label=f'Mean: {np.mean(scores):.3f}')
    ax3.axvline(x=max(scores), color='g', linestyle='--', label=f'Best: {max(scores):.3f}')
    ax3.set_xlabel('Score')
    ax3.set_ylabel('Count')
    ax3.set_title('Score Distribution')
    ax3.legend()
    
    # 4. 得分 vs 成功率
    ax4 = axes[1, 1]
    scatter = ax4.scatter(success_rates, scores, c=trials, cmap='viridis', alpha=0.7)
    ax4.set_xlabel('Success Rate')
    ax4.set_ylabel('Score')
    ax4.set_title('Score vs Success Rate')
    plt.colorbar(scatter, ax=ax4, label='Trial Number')
    ax4.grid(True, alpha=0.3)
    
    plt.tight_layout()
    
    output_file = output_dir / 'optimization_history.png'
    plt.savefig(output_file, dpi=150, bbox_inches='tight')
    print(f"\n图表已保存: {output_file}")
    plt.close()


def plot_parameter_importance(results, output_dir):
    """绘制参数重要性分析图"""
    if not HAS_MATPLOTLIB or len(results) < 10:
        return
    
    output_dir = Path(output_dir)
    
    # 提取参数和得分
    scores = np.array([r['score'] for r in results])
    param_keys = list(results[0]['params'].keys())
    
    # 计算每个参数与得分的相关性
    correlations = {}
    for key in param_keys:
        values = [r['params'][key] for r in results]
        if isinstance(values[0], (int, float)):
            corr = np.corrcoef(values, scores)[0, 1]
            if not np.isnan(corr):
                correlations[key] = corr
    
    # 排序
    sorted_params = sorted(correlations.items(), key=lambda x: abs(x[1]), reverse=True)
    
    # 绘图
    fig, ax = plt.subplots(figsize=(12, 8))
    
    names = [p[0] for p in sorted_params]
    values = [p[1] for p in sorted_params]
    colors = ['green' if v > 0 else 'red' for v in values]
    
    bars = ax.barh(names, values, color=colors, alpha=0.7)
    ax.axvline(x=0, color='black', linewidth=0.5)
    ax.set_xlabel('Correlation with Score')
    ax.set_title('Parameter Importance (Correlation Analysis)')
    ax.grid(True, alpha=0.3, axis='x')
    
    # 添加数值标签
    for bar, val in zip(bars, values):
        width = bar.get_width()
        ax.text(width + 0.01 if width > 0 else width - 0.01, 
                bar.get_y() + bar.get_height()/2,
                f'{val:.3f}', 
                ha='left' if width > 0 else 'right', 
                va='center', fontsize=8)
    
    plt.tight_layout()
    
    output_file = output_dir / 'parameter_importance.png'
    plt.savefig(output_file, dpi=150, bbox_inches='tight')
    print(f"参数重要性图已保存: {output_file}")
    plt.close()


def generate_report(result_dir):
    """生成完整报告"""
    result_dir = Path(result_dir)
    
    print("=" * 60)
    print("Optuna 导航参数优化报告")
    print("=" * 60)
    
    # 加载数据
    results = load_results(result_dir)
    best_params = load_best_params(result_dir)
    
    if not results:
        return
    
    # 打印摘要
    print_summary(results, best_params)
    
    # 生成图表
    if HAS_MATPLOTLIB:
        print("\n生成可视化图表...")
        plot_optimization_history(results, result_dir)
        plot_parameter_importance(results, result_dir)
    
    # 生成 Markdown 报告
    report_file = result_dir / "optimization_report.md"
    with open(report_file, 'w') as f:
        f.write("# Optuna 导航参数优化报告\n\n")
        f.write(f"## 优化摘要\n\n")
        f.write(f"- **总试验次数**: {len(results)}\n")
        scores = [r['score'] for r in results]
        f.write(f"- **最佳得分**: {max(scores):.4f}\n")
        f.write(f"- **平均得分**: {np.mean(scores):.4f} ± {np.std(scores):.4f}\n")
        
        if best_params:
            f.write(f"\n## 最佳参数\n\n")
            f.write("| 参数 | 值 |\n")
            f.write("|------|----|\n")
            for key, value in sorted(best_params['params'].items()):
                if isinstance(value, float):
                    f.write(f"| {key} | {value:.4f} |\n")
                else:
                    f.write(f"| {key} | {value} |\n")
        
        if HAS_MATPLOTLIB:
            f.write(f"\n## 可视化\n\n")
            f.write("![优化历史](optimization_history.png)\n\n")
            f.write("![参数重要性](parameter_importance.png)\n")
    
    print(f"\n报告已保存: {report_file}")


def main():
    parser = argparse.ArgumentParser(description='Optuna 优化结果可视化')
    parser.add_argument('--result-dir', '-r', 
                       default='/home/liyaxin075/Documents/robot_learning/optuna_results',
                       help='结果目录路径')
    args = parser.parse_args()
    
    generate_report(args.result_dir)


if __name__ == '__main__':
    main()
