#!/bin/bash
# ============================================================
# Optuna 多Worker分布式训练启动脚本
# 
# 使用方法:
#   单Worker:  ./start_distributed_optuna.sh 0 1
#   多Worker:  ./start_distributed_optuna.sh <worker_id> <n_workers>
#
# 示例 (4个Worker并行):
#   终端1: ./start_distributed_optuna.sh 0 4
#   终端2: ./start_distributed_optuna.sh 1 4
#   终端3: ./start_distributed_optuna.sh 2 4
#   终端4: ./start_distributed_optuna.sh 3 4
#
# 前置要求:
#   1. MySQL/PostgreSQL 数据库已配置好
#   2. 在 optuna_config.yaml 中配置好 storage_url
#   3. 每个Worker需要独立的ROS环境和Gazebo仿真
# ============================================================

set -e

# 解析参数
WORKER_ID=${1:-0}
N_WORKERS=${2:-1}

echo "=============================================="
echo "Optuna 分布式训练 - Worker $WORKER_ID / $N_WORKERS"
echo "=============================================="

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/optuna_config.yaml"

# 计算ROS端口偏移 (避免多个roscore冲突)
ROS_MASTER_PORT=$((11311 + WORKER_ID))
GAZEBO_PORT=$((11345 + WORKER_ID))

# 设置环境变量
export ROS_MASTER_URI="http://localhost:$ROS_MASTER_PORT"
export GAZEBO_MASTER_URI="http://localhost:$GAZEBO_PORT"

echo "ROS_MASTER_URI: $ROS_MASTER_URI"
echo "GAZEBO_MASTER_URI: $GAZEBO_MASTER_URI"

# 创建临时配置文件 (修改worker_id)
TEMP_CONFIG="/tmp/optuna_config_worker_${WORKER_ID}.yaml"
cp "$CONFIG_FILE" "$TEMP_CONFIG"

# 使用sed修改配置文件中的worker配置
sed -i "s/worker_id:.*/worker_id: $WORKER_ID/" "$TEMP_CONFIG"
sed -i "s/n_workers:.*/n_workers: $N_WORKERS/" "$TEMP_CONFIG"
sed -i "s/enabled: false/enabled: true/" "$TEMP_CONFIG"
sed -i "s/gazebo_port_offset:.*/gazebo_port_offset: $WORKER_ID/" "$TEMP_CONFIG"

echo "临时配置文件: $TEMP_CONFIG"

# 提示用户启动Gazebo
echo ""
echo "=============================================="
echo "请先启动对应的Gazebo仿真环境:"
echo ""
echo "  # 在新终端中运行:"
echo "  export ROS_MASTER_URI=http://localhost:$ROS_MASTER_PORT"
echo "  export GAZEBO_MASTER_URI=http://localhost:$GAZEBO_PORT"
echo "  roscore -p $ROS_MASTER_PORT &"
echo "  roslaunch bobac3_navigation gazebo_headless.launch"
echo ""
echo "=============================================="
echo ""

read -p "Gazebo已启动? 按Enter继续..."

# 复制临时配置到原位置 (或直接修改)
cp "$TEMP_CONFIG" "$CONFIG_FILE"

# 启动优化器
echo "启动 Optuna 优化器 (Worker $WORKER_ID)..."
cd "$SCRIPT_DIR"
python3 optuna_nav_optimizer.py

echo "Worker $WORKER_ID 完成"
