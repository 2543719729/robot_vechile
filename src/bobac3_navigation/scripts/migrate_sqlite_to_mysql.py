#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
将 SQLite 中的 Optuna 数据迁移到 MySQL
保留所有已完成的 trials 数据
"""

import optuna
from pathlib import Path

# 数据库配置
SQLITE_PATH = Path("/home/liyaxin075/Documents/robot_learning/optuna_results/optuna_study.db")
SQLITE_URL = f"sqlite:///{SQLITE_PATH}"
MYSQL_URL = "mysql+pymysql://optuna:optuna123@localhost:3306/optuna_db"
STUDY_NAME = "nav_param_optimization"

def migrate():
    """执行迁移"""
    
    # 检查 SQLite 文件是否存在
    if not SQLITE_PATH.exists():
        print(f"❌ SQLite 数据库不存在: {SQLITE_PATH}")
        return False
    
    print("=" * 60)
    print("Optuna 数据迁移: SQLite -> MySQL")
    print("=" * 60)
    print(f"源数据库: {SQLITE_PATH}")
    print(f"目标数据库: MySQL optuna_db")
    print()
    
    # 1. 加载 SQLite study
    try:
        sqlite_study = optuna.load_study(
            study_name=STUDY_NAME,
            storage=SQLITE_URL
        )
        print(f"✓ 已加载 SQLite Study: {STUDY_NAME}")
    except KeyError:
        print(f"❌ SQLite 中未找到 Study: {STUDY_NAME}")
        return False
    
    # 统计 SQLite 数据
    sqlite_trials = sqlite_study.trials
    completed = [t for t in sqlite_trials if t.state == optuna.trial.TrialState.COMPLETE]
    print(f"  - 总 Trials: {len(sqlite_trials)}")
    print(f"  - 已完成: {len(completed)}")
    
    if len(completed) > 0:
        best = sqlite_study.best_trial
        print(f"  - 最佳得分: {best.value:.4f} (Trial #{best.number})")
    print()
    
    # 2. 创建或加载 MySQL study
    try:
        mysql_study = optuna.load_study(
            study_name=STUDY_NAME,
            storage=MYSQL_URL
        )
        existing_trials = len(mysql_study.trials)
        print(f"✓ MySQL Study 已存在，当前有 {existing_trials} 个 trials")
    except KeyError:
        mysql_study = optuna.create_study(
            study_name=STUDY_NAME,
            storage=MYSQL_URL,
            direction="maximize"
        )
        existing_trials = 0
        print(f"✓ 已创建新的 MySQL Study")
    
    # 3. 迁移数据 (使用 enqueue 方式添加已完成的 trials)
    print()
    print("开始迁移数据...")
    migrated = 0
    skipped = 0
    
    for trial in sqlite_trials:
        if trial.state != optuna.trial.TrialState.COMPLETE:
            skipped += 1
            continue
        
        # 使用 add_trial 添加历史 trial
        try:
            mysql_study.add_trial(
                optuna.trial.create_trial(
                    params=trial.params,
                    distributions=trial.distributions,
                    values=[trial.value],
                    state=optuna.trial.TrialState.COMPLETE,
                    user_attrs=trial.user_attrs,
                    system_attrs=trial.system_attrs,
                )
            )
            migrated += 1
            if migrated % 10 == 0:
                print(f"  已迁移 {migrated} 个 trials...")
        except Exception as e:
            print(f"  ⚠ Trial #{trial.number} 迁移失败: {e}")
    
    print()
    print("=" * 60)
    print("迁移完成!")
    print("=" * 60)
    print(f"成功迁移: {migrated} 个 trials")
    print(f"跳过 (未完成): {skipped} 个 trials")
    print()
    
    # 4. 验证迁移结果
    mysql_study = optuna.load_study(
        study_name=STUDY_NAME,
        storage=MYSQL_URL
    )
    mysql_completed = [t for t in mysql_study.trials if t.state == optuna.trial.TrialState.COMPLETE]
    
    print("MySQL 数据库现状:")
    print(f"  - 总 Trials: {len(mysql_study.trials)}")
    print(f"  - 已完成: {len(mysql_completed)}")
    
    if len(mysql_completed) > 0:
        best = mysql_study.best_trial
        print(f"  - 最佳得分: {best.value:.4f} (Trial #{best.number})")
    
    return True

if __name__ == '__main__':
    import sys
    
    print()
    print("⚠️  此操作将把 SQLite 数据迁移到 MySQL")
    print("   SQLite 原始数据不会被删除")
    print()
    
    if len(sys.argv) > 1 and sys.argv[1] == '--yes':
        migrate()
    else:
        response = input("确认迁移? (y/N): ")
        if response.lower() == 'y':
            migrate()
        else:
            print("已取消")
