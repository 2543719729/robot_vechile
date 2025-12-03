#!/bin/bash
# Optuna 导航参数优化器启动脚本

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WS_DIR="/home/liyaxin075/Documents/robot_learning"

echo "=========================================="
echo "  Optuna TPE 导航参数优化器"
echo "=========================================="

# 检查 ROS 环境
if [ -z "$ROS_DISTRO" ]; then
    echo "错误: ROS 环境未设置"
    echo "请先运行: source /opt/ros/<distro>/setup.bash"
    exit 1
fi

# Source 工作空间
if [ -f "$WS_DIR/devel/setup.bash" ]; then
    source "$WS_DIR/devel/setup.bash"
    echo "已加载工作空间: $WS_DIR"
else
    echo "警告: 工作空间未编译，请先运行 catkin_make"
fi

# 检查 Python 依赖
echo ""
echo "检查 Python 依赖..."
python3 -c "import optuna" 2>/dev/null || {
    echo "安装 Optuna..."
    pip3 install optuna
}

python3 -c "import yaml" 2>/dev/null || {
    echo "安装 PyYAML..."
    pip3 install pyyaml
}

python3 -c "import numpy" 2>/dev/null || {
    echo "安装 NumPy..."
    pip3 install numpy
}

echo "依赖检查完成"

# 创建结果目录
RESULT_DIR="$WS_DIR/optuna_results"
mkdir -p "$RESULT_DIR"
echo "结果将保存到: $RESULT_DIR"

# 备份当前参数（与 move_base_sim.launch 一致）
echo ""
echo "备份当前导航参数..."
BACKUP_DIR="$RESULT_DIR/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp "$WS_DIR/src/bobac3_navigation/param/sim/"*.yaml "$BACKUP_DIR/"
echo "参数已备份到: $BACKUP_DIR"

echo ""
echo "=========================================="
echo "  准备工作完成，开始优化"
echo "=========================================="
echo ""
echo "注意事项:"
echo "  1. 确保仿真环境已启动 (Gazebo + move_base)"
echo "  2. 确保机器人可以接收导航目标"
echo "  3. 按 Ctrl+C 可安全中断优化"
echo ""
read -p "按 Enter 开始优化，或 Ctrl+C 取消..."

# 运行优化器
echo ""
echo "启动优化器..."
python3 "$SCRIPT_DIR/optuna_nav_optimizer.py"

echo ""
echo "=========================================="
echo "  优化完成"
echo "=========================================="
echo "查看结果: $RESULT_DIR"
