#!/bin/bash
# ============================================================
# 服务器端 Optuna 训练一键启动脚本
# 
# 使用方法:
#   ./server_train.sh              # 单Worker训练
#   ./server_train.sh --workers 4  # 4个Worker并行训练
#
# 前置要求:
#   1. ROS环境已配置 (source /opt/ros/noetic/setup.bash)
#   2. catkin_ws 已编译 (source ~/catkin_ws/devel/setup.bash)
#   3. 如果使用多Worker: MySQL/PostgreSQL已配置
# ============================================================

# 不使用 set -e，因为某些命令（如killall找不到进程）会返回非0退出码
# set -e

# 默认参数
N_WORKERS=1
WORKER_ID=0
HEADLESS=true
SCREEN_SESSION="optuna_train"

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --workers)
            N_WORKERS="$2"
            shift 2
            ;;
        --worker-id)
            WORKER_ID="$2"
            shift 2
            ;;
        --gui)
            HEADLESS=false
            shift
            ;;
        -h|--help)
            echo "用法: $0 [选项]"
            echo ""
            echo "选项:"
            echo "  --workers N      启动N个并行Worker (默认: 1)"
            echo "  --worker-id ID   指定当前Worker ID (默认: 0)"
            echo "  --gui            启用Gazebo GUI (默认: headless)"
            echo "  -h, --help       显示帮助信息"
            exit 0
            ;;
        *)
            echo "未知参数: $1"
            exit 1
            ;;
    esac
done

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"

echo "=============================================="
echo "Optuna 服务器端训练"
echo "=============================================="
echo "Workers: $N_WORKERS"
echo "Worker ID: $WORKER_ID"
echo "Headless: $HEADLESS"
echo "Workspace: $WORKSPACE_DIR"
echo "=============================================="

# Source ROS环境
if [ -f "/opt/ros/noetic/setup.bash" ]; then
    source /opt/ros/noetic/setup.bash
fi

if [ -f "$WORKSPACE_DIR/devel/setup.bash" ]; then
    source "$WORKSPACE_DIR/devel/setup.bash"
fi

# WSL2 Gazebo 兼容性设置
export SVGA_VGPU10=0
export LIBGL_ALWAYS_SOFTWARE=1
export MESA_GL_VERSION_OVERRIDE=3.3

# Gazebo 资源路径
export GAZEBO_RESOURCE_PATH=/usr/share/gazebo-11:${GAZEBO_RESOURCE_PATH}
export GAZEBO_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/gazebo-11/plugins:${GAZEBO_PLUGIN_PATH}
export GAZEBO_MODEL_PATH=/usr/share/gazebo-11/models:${GAZEBO_MODEL_PATH}
export OGRE_RESOURCE_PATH=/usr/lib/x86_64-linux-gnu/OGRE-1.9.0

# 计算端口
ROS_MASTER_PORT=$((11311 + WORKER_ID))
GAZEBO_PORT=$((11345 + WORKER_ID))

export ROS_MASTER_URI="http://127.0.0.1:$ROS_MASTER_PORT"
export GAZEBO_MASTER_URI="http://127.0.0.1:$GAZEBO_PORT"

# 单机多Worker模式：强制使用 localhost，禁用多播
export ROS_IP=127.0.0.1
export ROS_HOSTNAME=127.0.0.1
export IGN_IP=127.0.0.1
export GAZEBO_IP=127.0.0.1

echo ""
echo "ROS_MASTER_URI: $ROS_MASTER_URI"
echo "GAZEBO_MASTER_URI: $GAZEBO_MASTER_URI"
echo ""

# 检查端口是否被占用（只清理当前 worker 的进程）
echo "检查端口 $ROS_MASTER_PORT 和 $GAZEBO_PORT..."

# 检查 ROS 端口
if ss -tlnp | grep -q ":$ROS_MASTER_PORT "; then
    echo "警告: ROS 端口 $ROS_MASTER_PORT 已被占用，尝试清理..."
    fuser -k $ROS_MASTER_PORT/tcp 2>/dev/null || true
    sleep 1
fi

# 检查 Gazebo 端口
if ss -tlnp | grep -q ":$GAZEBO_PORT "; then
    echo "警告: Gazebo 端口 $GAZEBO_PORT 已被占用，尝试清理..."
    fuser -k $GAZEBO_PORT/tcp 2>/dev/null || true
    sleep 1
fi

sleep 1

# 检查当前端口的 roscore 是否在运行
if ! ROS_MASTER_URI="http://localhost:$ROS_MASTER_PORT" rostopic list &>/dev/null 2>&1; then
    echo "启动 roscore (端口 $ROS_MASTER_PORT)..."
    roscore -p $ROS_MASTER_PORT &
    ROSCORE_PID=$!
    sleep 3
else
    echo "roscore 已在端口 $ROS_MASTER_PORT 运行"
    ROSCORE_PID=""
fi

# 启动Gazebo仿真
echo "启动 Gazebo 仿真 (headless=$HEADLESS)..."
if [ "$HEADLESS" = true ]; then
    roslaunch bobac3_description gazebo_headless.launch &
else
    roslaunch bobac3_description gazebo.launch open_rviz:=false &
fi
GAZEBO_PID=$!
sleep 15  # 等待Gazebo完全启动和模型加载稳定

# 注意：不要在这里调用 delete_model，因为 gazebo_headless.launch 已经包含了 spawn_model
# 删除模型会导致刚 spawn 的机器人被删除，引发 Gazebo 状态混乱

# 启动地图服务器 (关键！AMCL和move_base都依赖地图)
echo "启动地图服务器..."
roslaunch bobac3_navigation map_server.launch map_file:=demo &
MAP_PID=$!
sleep 2

# 启动AMCL定位 (需要地图，所以先于move_base启动)
echo "启动 AMCL 定位..."
roslaunch bobac3_navigation amcl_sim.launch &
AMCL_PID=$!
sleep 3

# 启动导航栈
echo "启动导航栈 (move_base)..."
roslaunch bobac3_navigation move_base_sim.launch &
MOVEBASE_PID=$!
sleep 5

# 通过环境变量配置分布式训练（避免多 worker 同时修改配置文件）
if [ $N_WORKERS -gt 1 ]; then
    echo "配置分布式训练模式 (Worker $WORKER_ID/$N_WORKERS)..."
    export OPTUNA_DISTRIBUTED="true"
    export OPTUNA_WORKER_ID="$WORKER_ID"
    export OPTUNA_N_WORKERS="$N_WORKERS"
fi

# 启动Optuna优化器
echo ""
echo "=============================================="
echo "启动 Optuna 优化器 (Worker $WORKER_ID)..."
echo "=============================================="
cd "$SCRIPT_DIR"
python3 optuna_nav_optimizer.py

# 清理
echo "清理进程..."
if [ -n "$AMCL_PID" ]; then kill $AMCL_PID 2>/dev/null || true; fi
if [ -n "$MOVEBASE_PID" ]; then kill $MOVEBASE_PID 2>/dev/null || true; fi
if [ -n "$MAP_PID" ]; then kill $MAP_PID 2>/dev/null || true; fi
if [ -n "$GAZEBO_PID" ]; then kill $GAZEBO_PID 2>/dev/null || true; fi
if [ -n "$ROSCORE_PID" ]; then kill $ROSCORE_PID 2>/dev/null || true; fi

echo "训练完成"
