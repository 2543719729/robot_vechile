#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Optuna TPE 导航参数优化器
使用黑盒优化自动调整 move_base 导航参数
"""

import os
import sys
import time
import yaml
import math
import signal
import subprocess
import random
import numpy as np
from datetime import datetime
import pathlib  # 使用 pathlib 而不是 from pathlib import Path，避免与 nav_msgs.msg.Path 冲突

import rospy
import actionlib
from geometry_msgs.msg import PoseStamped, Twist, PoseWithCovarianceStamped
from nav_msgs.msg import Odometry, Path as NavPath  # 重命名避免冲突
from move_base_msgs.msg import MoveBaseAction, MoveBaseGoal
from actionlib_msgs.msg import GoalStatus
from std_srvs.srv import Empty
from gazebo_msgs.srv import SetModelState
from gazebo_msgs.msg import ModelState

import optuna
from optuna.samplers import TPESampler
from optuna.pruners import MedianPruner

# Dynamic Reconfigure 支持
try:
    import dynamic_reconfigure.client
    DYNRECONF_AVAILABLE = True
except ImportError:
    DYNRECONF_AVAILABLE = False

# ============== 配置区域 ==============
class Config:
    # 参数文件路径
    PARAM_DIR = pathlib.Path("/home/liyaxin075/Documents/robot_learning/src/bobac3_navigation/param/sim")
    CONFIG_FILE = pathlib.Path(__file__).parent / "optuna_config.yaml"
    
    # 测试场景：来自语音导航 voice_nav.cpp 的真实目标点
    # 场景类型: 'normal', 'narrow', 'obstacle'
    TEST_SCENARIOS = [
        # ===== 展馆目标点 (来自 voice_nav.cpp) =====
        {"goal": (1.055, 1.109, -0.024), "type": "normal", "weight": 1.0, "name": "深圳馆"},
        {"goal": (1.055, 2.120, 0.026), "type": "normal", "weight": 1.0, "name": "上海馆"},
        {"goal": (2.53, 0.155, 0.06), "type": "normal", "weight": 1.2, "name": "北京馆"},
        {"goal": (2.49, 1.150, -0.052), "type": "normal", "weight": 1.0, "name": "广州馆"},
        {"goal": (2.48, 2.120, -0.064), "type": "narrow", "weight": 1.3, "name": "吉林馆"},
    ]
    
    # 起始点/返回点配置
    START_POINT = {"goal": (0.0, 0.0, 0.0), "type": "normal", "weight": 1.5, "name": "充电点/起始点"}
    
    # 目标点访问策略
    VISIT_ALL_GOALS = True          # 每次trial访问所有目标点
    RANDOMIZE_GOAL_ORDER = True     # 随机化目标点访问顺序
    RETURN_TO_START = True          # 完成所有目标后返回起始点
    
    # 优化设置
    N_TRIALS = 50  # 优化次数
    TIMEOUT_PER_GOAL = 60.0  # 单个目标超时时间(秒)
    POSITION_TOLERANCE = 0.01  # 位置精度要求(米) - 与voice_nav精确导航一致
    
    # 权重设置 - 精度优先
    W_TIME = 0.15        # 时间权重 (降低)
    W_PRECISION = 0.45   # 精度权重 (最重要!)
    W_STABILITY = 0.25   # 稳定性权重 (精度需要稳定)
    W_NARROW = 0.08      # 窄通道通过能力权重
    W_SAFETY = 0.07      # 安全性权重
    
    # 卡顿检测配置
    STUCK_DETECTION = {
        'enabled': True,
        'low_speed_threshold': 0.02,
        'progress_threshold': 0.01,
        'cmd_vel_mismatch_threshold': 0.1,
        'penalty_weights': {
            'low_speed': 0.25,
            'no_progress': 0.25,
            'cmd_mismatch': 0.15,
            'oscillation': 0.15,
            'abnormal_motion': 0.10,
            'sudden_stop': 0.10,
        },
        'scenario_multipliers': {
            'normal': 0.15,
            'narrow': 0.25,
            'obstacle': 0.20,
        }
    }
    
    # 搜索空间（从配置文件加载）
    SEARCH_SPACE = {}
    
    @classmethod
    def load_from_yaml(cls):
        """从YAML配置文件加载设置"""
        if cls.CONFIG_FILE.exists():
            try:
                with open(cls.CONFIG_FILE, 'r') as f:
                    cfg = yaml.safe_load(f)
                
                # 加载优化设置
                if 'optimization' in cfg:
                    cls.N_TRIALS = cfg['optimization'].get('n_trials', cls.N_TRIALS)
                    cls.TIMEOUT_PER_GOAL = cfg['optimization'].get('timeout_per_goal', cls.TIMEOUT_PER_GOAL)
                    # 加载目标点访问策略
                    cls.VISIT_ALL_GOALS = cfg['optimization'].get('visit_all_goals', cls.VISIT_ALL_GOALS)
                    cls.RANDOMIZE_GOAL_ORDER = cfg['optimization'].get('randomize_goal_order', cls.RANDOMIZE_GOAL_ORDER)
                    cls.RETURN_TO_START = cfg['optimization'].get('return_to_start', cls.RETURN_TO_START)
                
                # 加载权重设置
                if 'weights' in cfg:
                    cls.W_TIME = cfg['weights'].get('time', cls.W_TIME)
                    cls.W_PRECISION = cfg['weights'].get('precision', cls.W_PRECISION)
                    cls.W_STABILITY = cfg['weights'].get('stability', cls.W_STABILITY)
                
                # 加载测试场景（5个目标馆）
                if 'test_scenarios' in cfg:
                    cls.TEST_SCENARIOS = []
                    for s in cfg['test_scenarios']:
                        cls.TEST_SCENARIOS.append({
                            'goal': tuple(s['goal']),
                            'type': s.get('type', 'normal'),
                            'weight': s.get('weight', 1.0),
                            'name': s['name']
                        })
                
                # 加载起始点/返回点
                if 'start_point' in cfg:
                    sp = cfg['start_point']
                    cls.START_POINT = {
                        'goal': tuple(sp['goal']),
                        'type': sp.get('type', 'normal'),
                        'weight': sp.get('weight', 1.5),
                        'name': sp.get('name', '起始点')
                    }
                
                # 加载搜索空间
                if 'search_space' in cfg:
                    cls.SEARCH_SPACE = cfg['search_space']
                    rospy.loginfo(f"已加载 {len(cls.SEARCH_SPACE)} 个参数的搜索空间")
                
                # 加载卡顿检测配置
                if 'stuck_detection' in cfg:
                    sd = cfg['stuck_detection']
                    cls.STUCK_DETECTION['enabled'] = sd.get('enabled', True)
                    cls.STUCK_DETECTION['low_speed_threshold'] = sd.get('low_speed_threshold', 0.02)
                    cls.STUCK_DETECTION['progress_threshold'] = sd.get('progress_threshold', 0.01)
                    cls.STUCK_DETECTION['cmd_vel_mismatch_threshold'] = sd.get('cmd_vel_mismatch_threshold', 0.1)
                    if 'penalty_weights' in sd:
                        cls.STUCK_DETECTION['penalty_weights'].update(sd['penalty_weights'])
                    if 'scenario_multipliers' in sd:
                        cls.STUCK_DETECTION['scenario_multipliers'].update(sd['scenario_multipliers'])
                    rospy.loginfo(f"卡顿检测: 已启用={cls.STUCK_DETECTION['enabled']}")
                
                rospy.loginfo(f"已从配置文件加载 {len(cls.TEST_SCENARIOS)} 个目标馆")
                rospy.loginfo(f"目标点策略: 随机顺序={cls.RANDOMIZE_GOAL_ORDER}, 返回起点={cls.RETURN_TO_START}")
            except Exception as e:
                rospy.logwarn(f"加载配置文件失败: {e}, 使用默认配置")


class NavigationEvaluator:
    """导航性能评估器 - 包含卡顿检测"""
    
    def __init__(self, config=None):
        self.config = config if config else Config
        self.current_pose = None
        self.current_vel = None
        self.path_length = 0.0
        self.oscillation_count = 0
        self.min_obstacle_dist = float('inf')
        self.velocity_history = []
        self.pose_history = []
        self.last_pose = None
        self.angular_changes = []
        
        # ========== 卡顿检测相关变量 ==========
        self.stuck_metrics = {
            'low_speed_duration': 0.0,      # 低速持续时间(秒)
            'zero_progress_duration': 0.0,  # 无进展持续时间(秒)
            'cmd_vel_mismatch_count': 0,    # 速度命令不匹配次数
            'oscillation_events': 0,        # 振荡事件次数
            'recovery_triggered': 0,        # 恢复行为触发次数
            'backward_motion_time': 0.0,    # 倒车时间
            'rotation_in_place_time': 0.0,  # 原地旋转时间
            'sudden_stop_count': 0,         # 急停次数
        }
        self.last_cmd_vel = None
        self.last_odom_vel = None
        self.last_goal_distance = None
        self.goal_position = None  # 当前目标点
        self.last_metric_time = None
        self.move_base_status = None
        
        # 卡顿检测阈值 (从配置加载)
        stuck_cfg = self.config.STUCK_DETECTION
        self.LOW_SPEED_THRESHOLD = stuck_cfg.get('low_speed_threshold', 0.02)
        self.CMD_VEL_MISMATCH_THRESHOLD = stuck_cfg.get('cmd_vel_mismatch_threshold', 0.1)
        self.PROGRESS_THRESHOLD = stuck_cfg.get('progress_threshold', 0.01)
        self.stuck_enabled = stuck_cfg.get('enabled', True)
        
        # 订阅话题
        self.odom_sub = rospy.Subscriber('/odom', Odometry, self.odom_callback)
        self.cmd_vel_sub = rospy.Subscriber('/cmd_vel', Twist, self.cmd_vel_callback)
        
        # 订阅 move_base 状态用于检测恢复行为
        self.move_base_status_sub = rospy.Subscriber(
            '/move_base_node/status', 
            GoalStatus, 
            self.move_base_status_callback,
            queue_size=1
        )
        
        # Move base action client（动作服务器名称为 'move_base'）
        self.move_base_client = actionlib.SimpleActionClient('move_base', MoveBaseAction)
        rospy.loginfo("等待 move_base 服务器...")
        self.move_base_client.wait_for_server(rospy.Duration(10.0))
        rospy.loginfo("move_base 服务器已连接")
        
        # 可选：单独清除全局 / 局部 costmap 的服务
        # 典型名字为：/move_base_node/global_costmap/clear 和 /move_base_node/local_costmap/clear
        self.clear_global_costmap = None
        self.clear_local_costmap = None
        try:
            rospy.wait_for_service('/move_base_node/global_costmap/clear', timeout=2.0)
            self.clear_global_costmap = rospy.ServiceProxy('/move_base_node/global_costmap/clear', Empty)
        except rospy.ROSException:
            pass
        try:
            rospy.wait_for_service('/move_base_node/local_costmap/clear', timeout=2.0)
            self.clear_local_costmap = rospy.ServiceProxy('/move_base_node/local_costmap/clear', Empty)
        except rospy.ROSException:
            pass
    
    def move_base_status_callback(self, msg):
        """move_base 状态回调 - 用于检测恢复行为"""
        # GoalStatus: PENDING=0, ACTIVE=1, PREEMPTED=2, SUCCEEDED=3, ABORTED=4, REJECTED=5, PREEMPTING=6, RECALLING=7, RECALLED=8, LOST=9
        self.move_base_status = msg.status if hasattr(msg, 'status') else None
    
    def odom_callback(self, msg):
        """里程计回调 - 增强版，包含卡顿检测"""
        current_time = rospy.Time.now().to_sec()
        self.current_pose = msg.pose.pose
        
        # 获取实际速度 (from odometry twist)
        actual_vx = msg.twist.twist.linear.x
        actual_vy = msg.twist.twist.linear.y
        actual_wz = msg.twist.twist.angular.z
        actual_speed = math.sqrt(actual_vx**2 + actual_vy**2)
        
        # 记录位置历史用于计算振荡
        pos = (msg.pose.pose.position.x, msg.pose.pose.position.y)
        self.pose_history.append((pos[0], pos[1], current_time))
        
        # 计算路径长度
        if self.last_pose is not None:
            dx = pos[0] - self.last_pose[0]
            dy = pos[1] - self.last_pose[1]
            self.path_length += math.sqrt(dx*dx + dy*dy)
        self.last_pose = pos
        
        # 计算角度变化 (用于振荡检测)
        q = msg.pose.pose.orientation
        yaw = math.atan2(2.0*(q.w*q.z + q.x*q.y), 1.0 - 2.0*(q.y*q.y + q.z*q.z))
        if len(self.angular_changes) > 0:
            delta_yaw = abs(yaw - self.angular_changes[-1])
            if delta_yaw > math.pi:
                delta_yaw = 2*math.pi - delta_yaw
            if delta_yaw > 0.3:  # 超过17度的角度变化
                self.oscillation_count += 1
                self.stuck_metrics['oscillation_events'] += 1
        self.angular_changes.append(yaw)
        
        # ========== 卡顿检测逻辑 ==========
        if self.last_metric_time is not None:
            dt = current_time - self.last_metric_time
            
            # 1. 低速检测
            if actual_speed < self.LOW_SPEED_THRESHOLD:
                self.stuck_metrics['low_speed_duration'] += dt
            
            # 2. 倒车检测 (负向速度)
            if actual_vx < -0.01:
                self.stuck_metrics['backward_motion_time'] += dt
            
            # 3. 原地旋转检测 (低线速度但高角速度)
            if actual_speed < 0.02 and abs(actual_wz) > 0.1:
                self.stuck_metrics['rotation_in_place_time'] += dt
            
            # 4. 进度检测 (是否在向目标靠近)
            if self.goal_position is not None:
                current_dist = math.sqrt(
                    (pos[0] - self.goal_position[0])**2 + 
                    (pos[1] - self.goal_position[1])**2
                )
                if self.last_goal_distance is not None:
                    progress = self.last_goal_distance - current_dist
                    if progress < -self.PROGRESS_THRESHOLD:  # 反向移动
                        self.stuck_metrics['zero_progress_duration'] += dt
                    elif abs(progress) < self.PROGRESS_THRESHOLD / 2:  # 几乎没有进展
                        self.stuck_metrics['zero_progress_duration'] += dt * 0.5
                self.last_goal_distance = current_dist
            
            # 5. cmd_vel 与实际速度不匹配检测
            if self.last_cmd_vel is not None:
                cmd_speed = math.sqrt(self.last_cmd_vel.linear.x**2 + self.last_cmd_vel.linear.y**2)
                if cmd_speed > 0.05 and actual_speed < 0.02:  # 有命令但不动
                    self.stuck_metrics['cmd_vel_mismatch_count'] += 1
        
        self.last_metric_time = current_time
        self.last_odom_vel = (actual_vx, actual_vy, actual_wz)
    
    def cmd_vel_callback(self, msg):
        """速度命令回调 - 增强版"""
        current_time = rospy.Time.now().to_sec()
        
        # 检测急停 (速度突然从高变为0)
        if self.last_cmd_vel is not None:
            prev_speed = math.sqrt(self.last_cmd_vel.linear.x**2 + self.last_cmd_vel.linear.y**2)
            curr_speed = math.sqrt(msg.linear.x**2 + msg.linear.y**2)
            if prev_speed > 0.1 and curr_speed < 0.01:
                self.stuck_metrics['sudden_stop_count'] += 1
        
        self.current_vel = msg
        self.last_cmd_vel = msg
        self.velocity_history.append({
            'linear_x': msg.linear.x,
            'linear_y': msg.linear.y,
            'angular_z': msg.angular.z,
            'time': current_time
        })
    
    def reset_metrics(self):
        """重置评估指标"""
        self.path_length = 0.0
        self.oscillation_count = 0
        self.min_obstacle_dist = float('inf')
        self.velocity_history = []
        self.pose_history = []
        self.last_pose = None
        self.angular_changes = []
        
        # 重置卡顿检测指标
        self.stuck_metrics = {
            'low_speed_duration': 0.0,
            'zero_progress_duration': 0.0,
            'cmd_vel_mismatch_count': 0,
            'oscillation_events': 0,
            'recovery_triggered': 0,
            'backward_motion_time': 0.0,
            'rotation_in_place_time': 0.0,
            'sudden_stop_count': 0,
        }
        self.last_cmd_vel = None
        self.last_odom_vel = None
        self.last_goal_distance = None
        self.last_metric_time = None
    
    def calculate_stuck_penalty(self, elapsed_time):
        """
        计算卡顿惩罚分数 (0-1, 0表示无卡顿, 1表示严重卡顿)
        
        基于多个维度综合评估:
        1. 低速时间比例
        2. 无进展时间比例  
        3. 速度命令不匹配次数
        4. 振荡事件频率
        5. 倒车和原地旋转时间
        6. 急停次数
        """
        # 如果卡顿检测未启用，返回0
        if not self.stuck_enabled:
            return 0.0
            
        if elapsed_time < 1.0:
            return 0.0
        
        # 从配置获取权重
        pw = self.config.STUCK_DETECTION.get('penalty_weights', {})
        w_low_speed = pw.get('low_speed', 0.25)
        w_no_progress = pw.get('no_progress', 0.25)
        w_cmd_mismatch = pw.get('cmd_mismatch', 0.15)
        w_oscillation = pw.get('oscillation', 0.15)
        w_abnormal = pw.get('abnormal_motion', 0.10)
        w_sudden_stop = pw.get('sudden_stop', 0.10)
        
        penalties = []
        
        # 1. 低速时间比例惩罚
        low_speed_ratio = self.stuck_metrics['low_speed_duration'] / elapsed_time
        penalties.append(min(low_speed_ratio * 2, 1.0) * w_low_speed)
        
        # 2. 无进展时间比例惩罚
        no_progress_ratio = self.stuck_metrics['zero_progress_duration'] / elapsed_time
        penalties.append(min(no_progress_ratio * 2, 1.0) * w_no_progress)
        
        # 3. cmd_vel 不匹配惩罚 (每10次不匹配扣满分)
        mismatch_penalty = min(self.stuck_metrics['cmd_vel_mismatch_count'] / 10.0, 1.0)
        penalties.append(mismatch_penalty * w_cmd_mismatch)
        
        # 4. 振荡事件惩罚 (每5次振荡扣满分)
        oscillation_penalty = min(self.stuck_metrics['oscillation_events'] / 5.0, 1.0)
        penalties.append(oscillation_penalty * w_oscillation)
        
        # 5. 倒车+原地旋转时间惩罚
        abnormal_motion_time = (self.stuck_metrics['backward_motion_time'] + 
                                self.stuck_metrics['rotation_in_place_time'])
        abnormal_ratio = abnormal_motion_time / elapsed_time
        penalties.append(min(abnormal_ratio * 3, 1.0) * w_abnormal)
        
        # 6. 急停惩罚 (每3次急停扣满分)
        sudden_stop_penalty = min(self.stuck_metrics['sudden_stop_count'] / 3.0, 1.0)
        penalties.append(sudden_stop_penalty * w_sudden_stop)
        
        total_penalty = sum(penalties)
        return min(total_penalty, 1.0)
    
    def get_stuck_summary(self):
        """获取卡顿检测摘要"""
        return (f"低速:{self.stuck_metrics['low_speed_duration']:.1f}s, "
                f"无进展:{self.stuck_metrics['zero_progress_duration']:.1f}s, "
                f"振荡:{self.stuck_metrics['oscillation_events']}, "
                f"急停:{self.stuck_metrics['sudden_stop_count']}")
    
    def navigate_to_goal(self, x, y, yaw, timeout=60.0):
        """
        导航到目标点
        返回: (成功, 耗时, 最终位置误差)
        """
        self.reset_metrics()
        
        # 清除 costmap（如果对应服务可用，不打印告警）
        try:
            cleared = False
            if self.clear_global_costmap is not None:
                self.clear_global_costmap()
                cleared = True
            if self.clear_local_costmap is not None:
                self.clear_local_costmap()
                cleared = True
            if cleared:
                rospy.sleep(0.5)
        except Exception:
            # 清理失败不影响主流程，静默忽略
            pass
        
        # 设置目标位置用于进度检测
        self.goal_position = (x, y)
        
        # 创建目标
        goal = MoveBaseGoal()
        goal.target_pose.header.frame_id = "map"
        goal.target_pose.header.stamp = rospy.Time.now()
        goal.target_pose.pose.position.x = x
        goal.target_pose.pose.position.y = y
        goal.target_pose.pose.orientation.z = math.sin(yaw / 2.0)
        goal.target_pose.pose.orientation.w = math.cos(yaw / 2.0)
        
        # 发送目标
        start_time = rospy.Time.now()
        self.move_base_client.send_goal(goal)
        
        # 分段等待结果，检测卡住状态
        check_interval = 3.0  # 每3秒检查一次
        stuck_threshold = 0.05  # 位移小于5cm认为卡住
        stuck_count = 0
        max_stuck_count = 3  # 连续3次卡住则放弃
        last_check_pose = None
        
        elapsed_time = 0.0
        finished = False
        
        while elapsed_time < timeout and not rospy.is_shutdown():
            # 等待一小段时间
            wait_time = min(check_interval, timeout - elapsed_time)
            finished = self.move_base_client.wait_for_result(rospy.Duration(wait_time))
            elapsed_time = (rospy.Time.now() - start_time).to_sec()
            
            if finished:
                break
            
            # 检测是否卡住
            if self.current_pose:
                current_pos = (self.current_pose.position.x, self.current_pose.position.y)
                if last_check_pose:
                    dx = current_pos[0] - last_check_pose[0]
                    dy = current_pos[1] - last_check_pose[1]
                    displacement = math.sqrt(dx*dx + dy*dy)
                    
                    if displacement < stuck_threshold:
                        stuck_count += 1
                        if stuck_count >= max_stuck_count:
                            rospy.logwarn(f"    机器人卡住超过{max_stuck_count * check_interval}秒，提前终止")
                            self.move_base_client.cancel_goal()
                            return False, elapsed_time, float('inf')
                    else:
                        stuck_count = 0  # 有移动，重置计数
                
                last_check_pose = current_pos
        
        end_time = rospy.Time.now()
        elapsed_time = (end_time - start_time).to_sec()
        
        if not finished:
            self.move_base_client.cancel_goal()
            return False, timeout, float('inf')
        
        state = self.move_base_client.get_state()
        
        # 计算最终位置误差
        if self.current_pose:
            dx = self.current_pose.position.x - x
            dy = self.current_pose.position.y - y
            position_error = math.sqrt(dx*dx + dy*dy)
        else:
            position_error = float('inf')
        
        success = (state == GoalStatus.SUCCEEDED)
        
        return success, elapsed_time, position_error
    
    def calculate_stability_score(self):
        """计算稳定性得分 (0-1, 越高越稳定)"""
        if len(self.velocity_history) < 2:
            return 0.5
        
        # 计算速度方差
        vx = [v['linear_x'] for v in self.velocity_history]
        vy = [v['linear_y'] for v in self.velocity_history]
        wz = [v['angular_z'] for v in self.velocity_history]
        
        var_vx = np.var(vx) if len(vx) > 1 else 0
        var_vy = np.var(vy) if len(vy) > 1 else 0
        var_wz = np.var(wz) if len(wz) > 1 else 0
        
        # 综合方差 (归一化)
        total_var = var_vx + var_vy + 0.5 * var_wz
        
        # 考虑振荡次数
        osc_penalty = min(self.oscillation_count * 0.05, 0.5)
        
        # 转换为得分
        stability = max(0, 1.0 - total_var - osc_penalty)
        return stability
    
    def calculate_efficiency_score(self, elapsed_time, direct_distance):
        """计算效率得分 (0-1)"""
        if direct_distance < 0.1:
            return 1.0
        
        # 路径效率: 实际路径 vs 直线距离
        path_efficiency = direct_distance / max(self.path_length, direct_distance)
        
        # 时间效率: 假设理想速度0.3m/s
        ideal_time = direct_distance / 0.3
        time_efficiency = min(ideal_time / max(elapsed_time, 0.1), 1.0)
        
        return 0.5 * path_efficiency + 0.5 * time_efficiency


class OptunaNavigationOptimizer:
    """Optuna 导航参数优化器"""
    
    def __init__(self):
        self.config = Config()
        self.evaluator = None
        self.best_score = -float('inf')
        self.best_params = None
        self.trial_results = []
        
        # 创建结果目录
        self.result_dir = pathlib.Path("/home/liyaxin075/Documents/robot_learning/optuna_results")
        self.result_dir.mkdir(exist_ok=True)
        
        # Dynamic Reconfigure 客户端
        self.dynreconf_clients = {}
        self._init_dynamic_reconfigure_clients()
    
    def _init_dynamic_reconfigure_clients(self):
        """初始化 dynamic_reconfigure 客户端，用于在线更新 move_base 参数"""
        if not DYNRECONF_AVAILABLE:
            rospy.logwarn("dynamic_reconfigure 未安装，将仅使用 YAML 文件更新参数")
            rospy.logwarn("安装方法: sudo apt install ros-noetic-dynamic-reconfigure")
            return
        
        # 定义需要连接的 dynamic_reconfigure 服务
        dynreconf_servers = {
            'teb': '/move_base_node/TebLocalPlannerROS',
            'global_inflation': '/move_base_node/global_costmap/inflation_layer',
            'local_inflation': '/move_base_node/local_costmap/inflation_layer',
            'global_costmap': '/move_base_node/global_costmap',
            'local_costmap': '/move_base_node/local_costmap',
            'move_base': '/move_base_node',
        }
        
        for name, server in dynreconf_servers.items():
            try:
                rospy.loginfo(f"连接 dynamic_reconfigure 服务: {server}")
                client = dynamic_reconfigure.client.Client(server, timeout=5.0)
                self.dynreconf_clients[name] = client
                rospy.loginfo(f"  ✓ 已连接: {server}")
            except Exception as e:
                rospy.logwarn(f"  ✗ 无法连接 {server}: {e}")
                self.dynreconf_clients[name] = None
        
        connected = sum(1 for c in self.dynreconf_clients.values() if c is not None)
        rospy.loginfo(f"Dynamic Reconfigure: 已连接 {connected}/{len(dynreconf_servers)} 个服务")
        
    def define_search_space(self, trial):
        """定义参数搜索空间 - 从配置文件读取范围"""
        params = {}
        ss = self.config.SEARCH_SPACE  # 搜索空间配置
        
        # 辅助函数：从配置获取范围，如果不存在则使用默认值
        def get_range(key, default_min, default_max):
            if key in ss:
                return ss[key][0], ss[key][1]
            return default_min, default_max
        
        # ========== TEB 局部规划器参数 ==========
        # 速度参数
        r = get_range('teb_max_vel_x', 0.15, 0.35)
        params['teb_max_vel_x'] = trial.suggest_float('teb_max_vel_x', r[0], r[1])
        r = get_range('teb_max_vel_x_backwards', 0.1, 0.3)
        params['teb_max_vel_x_backwards'] = trial.suggest_float('teb_max_vel_x_backwards', r[0], r[1])
        r = get_range('teb_max_vel_y', 0.2, 0.5)
        params['teb_max_vel_y'] = trial.suggest_float('teb_max_vel_y', r[0], r[1])
        r = get_range('teb_max_vel_theta', 0.3, 0.8)
        params['teb_max_vel_theta'] = trial.suggest_float('teb_max_vel_theta', r[0], r[1])
        
        # 加速度参数
        r = get_range('teb_acc_lim_x', 0.15, 0.5)
        params['teb_acc_lim_x'] = trial.suggest_float('teb_acc_lim_x', r[0], r[1])
        r = get_range('teb_acc_lim_y', 0.15, 0.5)
        params['teb_acc_lim_y'] = trial.suggest_float('teb_acc_lim_y', r[0], r[1])
        r = get_range('teb_acc_lim_theta', 0.2, 0.6)
        params['teb_acc_lim_theta'] = trial.suggest_float('teb_acc_lim_theta', r[0], r[1])
        
        # 目标容差
        r = get_range('teb_xy_goal_tolerance', 0.02, 0.08)
        params['teb_xy_goal_tolerance'] = trial.suggest_float('teb_xy_goal_tolerance', r[0], r[1])
        r = get_range('teb_yaw_goal_tolerance', 0.08, 0.25)
        params['teb_yaw_goal_tolerance'] = trial.suggest_float('teb_yaw_goal_tolerance', r[0], r[1])
        
        # 轨迹参数
        r = get_range('teb_dt_ref', 0.15, 0.4)
        params['teb_dt_ref'] = trial.suggest_float('teb_dt_ref', r[0], r[1])
        r = get_range('teb_max_global_plan_lookahead_dist', 2.0, 5.0)
        params['teb_max_global_plan_lookahead_dist'] = trial.suggest_float('teb_max_global_plan_lookahead_dist', r[0], r[1])
        r = get_range('teb_global_plan_viapoint_sep', 0.1, 0.3)
        params['teb_global_plan_viapoint_sep'] = trial.suggest_float('teb_global_plan_viapoint_sep', r[0], r[1])
        
        # 障碍物处理
        r = get_range('teb_min_obstacle_dist', 0.20, 0.40)
        params['teb_min_obstacle_dist'] = trial.suggest_float('teb_min_obstacle_dist', r[0], r[1])
        r = get_range('teb_inflation_dist', 0.2, 0.5)
        params['teb_inflation_dist'] = trial.suggest_float('teb_inflation_dist', r[0], r[1])
        r = get_range('teb_obstacle_poses_affected', 15, 30)
        params['teb_obstacle_poses_affected'] = trial.suggest_int('teb_obstacle_poses_affected', int(r[0]), int(r[1]))
        
        # 优化迭代次数
        r = get_range('teb_no_inner_iterations', 4, 10)
        params['teb_no_inner_iterations'] = trial.suggest_int('teb_no_inner_iterations', int(r[0]), int(r[1]))
        r = get_range('teb_no_outer_iterations', 3, 8)
        params['teb_no_outer_iterations'] = trial.suggest_int('teb_no_outer_iterations', int(r[0]), int(r[1]))
        
        # TEB 权重配置
        r = get_range('teb_weight_obstacle', 1.0, 50.0)
        params['teb_weight_obstacle'] = trial.suggest_float('teb_weight_obstacle', r[0], r[1])
        r = get_range('teb_weight_inflation', 0.01, 0.2)
        params['teb_weight_inflation'] = trial.suggest_float('teb_weight_inflation', r[0], r[1])
        r = get_range('teb_weight_viapoint', 1.0, 50.0)
        params['teb_weight_viapoint'] = trial.suggest_float('teb_weight_viapoint', r[0], r[1])
        r = get_range('teb_weight_optimaltime', 0.1, 1.0)
        params['teb_weight_optimaltime'] = trial.suggest_float('teb_weight_optimaltime', r[0], r[1])
        r = get_range('teb_weight_acc_lim_x', 1.0, 5.0)
        params['teb_weight_acc_lim_x'] = trial.suggest_float('teb_weight_acc_lim_x', r[0], r[1])
        r = get_range('teb_weight_acc_lim_theta', 1.0, 5.0)
        params['teb_weight_acc_lim_theta'] = trial.suggest_float('teb_weight_acc_lim_theta', r[0], r[1])
        
        # ========== Costmap 参数 ==========
        # 膨胀层 - 关键参数！
        r = get_range('inflation_radius', 0.15, 0.35)
        params['inflation_radius'] = trial.suggest_float('inflation_radius', r[0], r[1])
        r = get_range('cost_scaling_factor', 3.0, 10.0)
        params['cost_scaling_factor'] = trial.suggest_float('cost_scaling_factor', r[0], r[1])
        
        # 障碍物层
        r = get_range('obstacle_range', 1.5, 3.5)
        params['obstacle_range'] = trial.suggest_float('obstacle_range', r[0], r[1])
        r = get_range('raytrace_range', 2.0, 4.0)
        params['raytrace_range'] = trial.suggest_float('raytrace_range', r[0], r[1])
        
        # Costmap 频率
        r = get_range('global_update_frequency', 0.5, 3.0)
        params['global_update_frequency'] = trial.suggest_float('global_update_frequency', r[0], r[1])
        r = get_range('local_update_frequency', 3.0, 10.0)
        params['local_update_frequency'] = trial.suggest_float('local_update_frequency', r[0], r[1])
        
        # Local Costmap 尺寸
        r = get_range('local_width', 1.5, 3.5)
        params['local_width'] = trial.suggest_float('local_width', r[0], r[1])
        r = get_range('local_height', 1.5, 3.5)
        params['local_height'] = trial.suggest_float('local_height', r[0], r[1])
        
        # ========== Move Base 参数 ==========
        r = get_range('controller_frequency', 10.0, 25.0)
        params['controller_frequency'] = trial.suggest_float('controller_frequency', r[0], r[1])
        r = get_range('planner_frequency', 0.5, 3.0)
        params['planner_frequency'] = trial.suggest_float('planner_frequency', r[0], r[1])
        
        # ========== 参数约束：排除已知会导致卡住的组合 ==========
        # 约束1: inflation_radius 必须小于 teb_min_obstacle_dist，否则会冲突
        if params['inflation_radius'] > params['teb_min_obstacle_dist']:
            raise optuna.TrialPruned("inflation_radius > teb_min_obstacle_dist 会导致卡住")
        
        # 约束2: teb_inflation_dist 必须 >= teb_min_obstacle_dist
        if params['teb_inflation_dist'] < params['teb_min_obstacle_dist']:
            raise optuna.TrialPruned("teb_inflation_dist < teb_min_obstacle_dist 会导致卡住")
        
        # 约束3: 速度不能太低，否则容易超时
        if params['teb_max_vel_x'] < 0.15:
            raise optuna.TrialPruned("teb_max_vel_x 太低会导致超时")
        
        # 约束4: planner_frequency 太低会导致路径更新不及时
        if params['planner_frequency'] < 0.8 and params['teb_max_vel_x'] > 0.3:
            raise optuna.TrialPruned("高速度需要更高的规划频率")
        
        return params
    
    def apply_params_to_yaml(self, params):
        """将参数应用到YAML配置文件 - TEB版本"""
        
        # 1. 更新 TEB 局部规划器参数
        teb_file = self.config.PARAM_DIR / "teb_local_planner_params.yaml"
        with open(teb_file, 'r') as f:
            teb_config = yaml.safe_load(f)
        
        teb = teb_config['TebLocalPlannerROS']
        
        # 速度参数
        teb['max_vel_x'] = params['teb_max_vel_x']
        teb['max_vel_x_backwards'] = params['teb_max_vel_x_backwards']
        teb['max_vel_y'] = params['teb_max_vel_y']
        teb['max_vel_theta'] = params['teb_max_vel_theta']
        
        # 加速度参数
        teb['acc_lim_x'] = params['teb_acc_lim_x']
        teb['acc_lim_y'] = params['teb_acc_lim_y']
        teb['acc_lim_theta'] = params['teb_acc_lim_theta']
        
        # 目标容差
        teb['xy_goal_tolerance'] = params['teb_xy_goal_tolerance']
        teb['yaw_goal_tolerance'] = params['teb_yaw_goal_tolerance']
        
        # 轨迹参数
        teb['dt_ref'] = params['teb_dt_ref']
        teb['max_global_plan_lookahead_dist'] = params['teb_max_global_plan_lookahead_dist']
        teb['global_plan_viapoint_sep'] = params['teb_global_plan_viapoint_sep']
        
        # 障碍物处理
        teb['min_obstacle_dist'] = params['teb_min_obstacle_dist']
        teb['inflation_dist'] = params['teb_inflation_dist']
        teb['obstacle_poses_affected'] = params['teb_obstacle_poses_affected']
        
        # 优化迭代
        teb['no_inner_iterations'] = params['teb_no_inner_iterations']
        teb['no_outer_iterations'] = params['teb_no_outer_iterations']
        
        # 权重配置
        teb['weight_obstacle'] = params['teb_weight_obstacle']
        teb['weight_inflation'] = params['teb_weight_inflation']
        teb['weight_viapoint'] = params['teb_weight_viapoint']
        teb['weight_optimaltime'] = params['teb_weight_optimaltime']
        teb['weight_acc_lim_x'] = params['teb_weight_acc_lim_x']
        teb['weight_acc_lim_theta'] = params['teb_weight_acc_lim_theta']
        
        with open(teb_file, 'w') as f:
            yaml.dump(teb_config, f, default_flow_style=False)
        
        # 2. 更新 Global Costmap 参数
        global_costmap_file = self.config.PARAM_DIR / "global_costmap_params.yaml"
        with open(global_costmap_file, 'r') as f:
            gc_config = yaml.safe_load(f)
        
        gc_config['global_costmap']['inflation_layer']['inflation_radius'] = params['inflation_radius']
        gc_config['global_costmap']['inflation_layer']['cost_scaling_factor'] = params['cost_scaling_factor']
        gc_config['global_costmap']['update_frequency'] = params['global_update_frequency']
        
        with open(global_costmap_file, 'w') as f:
            yaml.dump(gc_config, f, default_flow_style=False)
        
        # 3. 更新 Local Costmap 参数
        local_costmap_file = self.config.PARAM_DIR / "local_costmap_params.yaml"
        with open(local_costmap_file, 'r') as f:
            lc_config = yaml.safe_load(f)
        
        lc_config['local_costmap']['inflation_layer']['inflation_radius'] = params['inflation_radius']
        lc_config['local_costmap']['inflation_layer']['cost_scaling_factor'] = params['cost_scaling_factor']
        lc_config['local_costmap']['update_frequency'] = params['local_update_frequency']
        lc_config['local_costmap']['width'] = params['local_width']
        lc_config['local_costmap']['height'] = params['local_height']
        
        with open(local_costmap_file, 'w') as f:
            yaml.dump(lc_config, f, default_flow_style=False)
        
        # 4. 更新 Costmap Common 参数
        common_file = self.config.PARAM_DIR / "costmap_common_params.yaml"
        with open(common_file, 'r') as f:
            common_config = yaml.safe_load(f)
        
        common_config['obstacle_layer']['obstacle_range'] = params['obstacle_range']
        common_config['obstacle_layer']['raytrace_range'] = params['raytrace_range']
        
        with open(common_file, 'w') as f:
            yaml.dump(common_config, f, default_flow_style=False)
        
        # 5. 更新 Move Base 参数
        move_base_file = self.config.PARAM_DIR / "move_base_params.yaml"
        with open(move_base_file, 'r') as f:
            mb_config = yaml.safe_load(f)
        
        mb_config['controller_frequency'] = params['controller_frequency']
        mb_config['planner_frequency'] = params['planner_frequency']
        
        with open(move_base_file, 'w') as f:
            yaml.dump(mb_config, f, default_flow_style=False)
    
    def apply_params_dynamically(self, params):
        """使用 dynamic_reconfigure 在线更新 move_base 参数（无需重启节点）"""
        if not DYNRECONF_AVAILABLE or not self.dynreconf_clients:
            rospy.logwarn("dynamic_reconfigure 不可用，参数仅写入 YAML 文件")
            return False
        
        success_count = 0
        total_count = 0
        
        # 1. 更新 TEB 局部规划器参数
        if self.dynreconf_clients.get('teb'):
            total_count += 1
            try:
                teb_params = {
                    'max_vel_x': params['teb_max_vel_x'],
                    'max_vel_x_backwards': params['teb_max_vel_x_backwards'],
                    'max_vel_y': params['teb_max_vel_y'],
                    'max_vel_theta': params['teb_max_vel_theta'],
                    'acc_lim_x': params['teb_acc_lim_x'],
                    'acc_lim_y': params['teb_acc_lim_y'],
                    'acc_lim_theta': params['teb_acc_lim_theta'],
                    'xy_goal_tolerance': params['teb_xy_goal_tolerance'],
                    'yaw_goal_tolerance': params['teb_yaw_goal_tolerance'],
                    'dt_ref': params['teb_dt_ref'],
                    'max_global_plan_lookahead_dist': params['teb_max_global_plan_lookahead_dist'],
                    'global_plan_viapoint_sep': params['teb_global_plan_viapoint_sep'],
                    'min_obstacle_dist': params['teb_min_obstacle_dist'],
                    'inflation_dist': params['teb_inflation_dist'],
                    'obstacle_poses_affected': params['teb_obstacle_poses_affected'],
                    'no_inner_iterations': params['teb_no_inner_iterations'],
                    'no_outer_iterations': params['teb_no_outer_iterations'],
                    'weight_obstacle': params['teb_weight_obstacle'],
                    'weight_inflation': params['teb_weight_inflation'],
                    'weight_viapoint': params['teb_weight_viapoint'],
                    'weight_optimaltime': params['teb_weight_optimaltime'],
                    'weight_acc_lim_x': params['teb_weight_acc_lim_x'],
                    'weight_acc_lim_theta': params['teb_weight_acc_lim_theta'],
                }
                self.dynreconf_clients['teb'].update_configuration(teb_params)
                success_count += 1
                rospy.logdebug("TEB 参数已动态更新")
            except Exception as e:
                rospy.logwarn(f"TEB 动态更新失败: {e}")
        
        # 2. 更新 Global Costmap Inflation 参数
        if self.dynreconf_clients.get('global_inflation'):
            total_count += 1
            try:
                inflation_params = {
                    'inflation_radius': params['inflation_radius'],
                    'cost_scaling_factor': params['cost_scaling_factor'],
                }
                self.dynreconf_clients['global_inflation'].update_configuration(inflation_params)
                success_count += 1
                rospy.logdebug("Global Costmap Inflation 参数已动态更新")
            except Exception as e:
                rospy.logwarn(f"Global Inflation 动态更新失败: {e}")
        
        # 3. 更新 Local Costmap Inflation 参数
        if self.dynreconf_clients.get('local_inflation'):
            total_count += 1
            try:
                inflation_params = {
                    'inflation_radius': params['inflation_radius'],
                    'cost_scaling_factor': params['cost_scaling_factor'],
                }
                self.dynreconf_clients['local_inflation'].update_configuration(inflation_params)
                success_count += 1
                rospy.logdebug("Local Costmap Inflation 参数已动态更新")
            except Exception as e:
                rospy.logwarn(f"Local Inflation 动态更新失败: {e}")
        
        # 4. 更新 Global Costmap 参数
        if self.dynreconf_clients.get('global_costmap'):
            total_count += 1
            try:
                costmap_params = {
                    'update_frequency': params['global_update_frequency'],
                }
                self.dynreconf_clients['global_costmap'].update_configuration(costmap_params)
                success_count += 1
                rospy.logdebug("Global Costmap 参数已动态更新")
            except Exception as e:
                rospy.logwarn(f"Global Costmap 动态更新失败: {e}")
        
        # 5. 更新 Local Costmap 参数
        if self.dynreconf_clients.get('local_costmap'):
            total_count += 1
            try:
                costmap_params = {
                    'update_frequency': params['local_update_frequency'],
                    'width': params['local_width'],
                    'height': params['local_height'],
                }
                self.dynreconf_clients['local_costmap'].update_configuration(costmap_params)
                success_count += 1
                rospy.logdebug("Local Costmap 参数已动态更新")
            except Exception as e:
                rospy.logwarn(f"Local Costmap 动态更新失败: {e}")
        
        # 6. 更新 Move Base 参数
        if self.dynreconf_clients.get('move_base'):
            total_count += 1
            try:
                mb_params = {
                    'controller_frequency': params['controller_frequency'],
                    'planner_frequency': params['planner_frequency'],
                }
                self.dynreconf_clients['move_base'].update_configuration(mb_params)
                success_count += 1
                rospy.logdebug("Move Base 参数已动态更新")
            except Exception as e:
                rospy.logwarn(f"Move Base 动态更新失败: {e}")
        
        rospy.loginfo(f"Dynamic Reconfigure: 成功更新 {success_count}/{total_count} 组参数")
        return success_count > 0
    
    def reload_params(self, params=None):
        """重新加载参数到运行中的 move_base 节点
        
        优先使用 dynamic_reconfigure 在线更新，如果失败则回退到等待方式
        """
        if params is not None and DYNRECONF_AVAILABLE:
            # 使用 dynamic_reconfigure 在线更新参数
            if self.apply_params_dynamically(params):
                # 短暂等待让参数生效
                rospy.sleep(0.3)
                return
        
        # 回退方案：等待一段时间（不重启 move_base）
        rospy.sleep(1.0)
    
    def evaluate_scenario(self, scenario):
        """评估单个场景"""
        goal = scenario['goal']
        scenario_type = scenario['type']
        weight = scenario['weight']
        name = scenario['name']
        
        rospy.loginfo(f"  测试场景: {name}")
        
        # 计算直线距离
        direct_distance = math.sqrt(goal[0]**2 + goal[1]**2)
        
        # 执行导航
        success, elapsed_time, position_error = self.evaluator.navigate_to_goal(
            goal[0], goal[1], goal[2], 
            timeout=self.config.TIMEOUT_PER_GOAL
        )
        
        if not success:
            rospy.logwarn(f"    场景 {name} 失败")
            return {
                'success': False,
                'score': 0.0,
                'weight': weight,
                'type': scenario_type
            }
        
        # 计算各项得分
        # 1. 时间得分 (归一化到0-1)
        ideal_time = direct_distance / 0.3  # 假设理想速度0.3m/s
        time_score = min(ideal_time / max(elapsed_time, 0.1), 1.0)
        
        # 2. 精度得分 - 精度优先，使用更严格的评估
        # 误差<1cm: 满分; 误差>5cm: 严重扣分
        if position_error <= 0.01:
            precision_score = 1.0  # 1cm以内满分
        elif position_error <= 0.02:
            precision_score = 0.95  # 2cm以内95分
        elif position_error <= 0.03:
            precision_score = 0.85  # 3cm以内85分
        elif position_error <= 0.05:
            precision_score = 0.70  # 5cm以内70分
        else:
            precision_score = max(0, 0.5 - (position_error - 0.05) * 5)  # 超过5cm快速衰减
        
        # 3. 稳定性得分
        stability_score = self.evaluator.calculate_stability_score()
        
        # 4. 效率得分
        efficiency_score = self.evaluator.calculate_efficiency_score(elapsed_time, direct_distance)
        
        # 5. 卡顿惩罚 (新增) - 基于多维度卡顿检测
        stuck_penalty = self.evaluator.calculate_stuck_penalty(elapsed_time)
        stuck_summary = self.evaluator.get_stuck_summary()
        
        # 获取场景类型对应的卡顿惩罚乘数
        sm = self.config.STUCK_DETECTION.get('scenario_multipliers', {})
        stuck_multiplier = sm.get(scenario_type, sm.get('normal', 0.15))
        
        # 根据场景类型调整权重 - 所有场景都重视精度
        if scenario_type == 'narrow':
            # 窄通道: 精度最重要
            base_score = (0.10 * time_score + 
                         0.45 * precision_score + 
                         0.25 * stability_score + 
                         0.10 * efficiency_score)
        elif scenario_type == 'obstacle':
            # 障碍绕行: 精度和稳定性
            base_score = (0.15 * time_score + 
                         0.35 * precision_score + 
                         0.25 * stability_score + 
                         0.15 * efficiency_score)
        else:
            # 普通场景: 精度优先
            base_score = (self.config.W_TIME * time_score + 
                         self.config.W_PRECISION * precision_score + 
                         self.config.W_STABILITY * stability_score + 
                         (1 - self.config.W_TIME - self.config.W_PRECISION - self.config.W_STABILITY) * efficiency_score)
        
        # 应用卡顿惩罚 (使用配置中的场景乘数)
        score = base_score * (1.0 - stuck_penalty * stuck_multiplier)
        
        rospy.loginfo(f"    得分: {score:.3f} (时间:{time_score:.2f}, 精度:{precision_score:.2f}[误差{position_error*100:.1f}cm], 稳定:{stability_score:.2f}, 卡顿惩罚:{stuck_penalty:.2f})")
        rospy.loginfo(f"    卡顿详情: {stuck_summary}")
        
        return {
            'success': True,
            'score': score,
            'weight': weight,
            'type': scenario_type,
            'time': elapsed_time,
            'error': position_error,
            'stuck_penalty': stuck_penalty,
            'stuck_metrics': self.evaluator.stuck_metrics.copy()
        }
    
    def reset_robot_pose(self):
        """重置机器人到初始位置"""
        try:
            # 0. 先取消当前的导航目标
            if hasattr(self, 'evaluator') and self.evaluator.move_base_client:
                self.evaluator.move_base_client.cancel_all_goals()
                rospy.sleep(0.2)
            
            # 1. 重置 Gazebo 中的机器人位置
            rospy.wait_for_service('/gazebo/set_model_state', timeout=2.0)
            set_state = rospy.ServiceProxy('/gazebo/set_model_state', SetModelState)
            
            state = ModelState()
            state.model_name = 'bobac3_serverbot'  # 机器人模型名称（与gazebo.launch中一致）
            state.pose.position.x = 0.0
            state.pose.position.y = 0.0
            state.pose.position.z = 0.0
            state.pose.orientation.x = 0.0
            state.pose.orientation.y = 0.0
            state.pose.orientation.z = 0.0
            state.pose.orientation.w = 1.0
            state.reference_frame = 'world'
            
            result = set_state(state)
            if not result.success:
                rospy.logwarn(f"Gazebo重置失败: {result.status_message}")
            
            rospy.sleep(0.3)  # 等待 Gazebo 物理位置更新
            
            # 2. 重置 AMCL 位置估计（多次发布确保接收）
            if not hasattr(self, '_initial_pose_pub'):
                self._initial_pose_pub = rospy.Publisher('/initialpose', PoseWithCovarianceStamped, queue_size=10)
                rospy.sleep(0.2)  # 等待 publisher 连接
            
            pose_msg = PoseWithCovarianceStamped()
            pose_msg.header.frame_id = 'map'
            pose_msg.pose.pose.position.x = 0.0
            pose_msg.pose.pose.position.y = 0.0
            pose_msg.pose.pose.position.z = 0.0
            pose_msg.pose.pose.orientation.w = 1.0
            # 设置较小的协方差，表示位置确定性高
            pose_msg.pose.covariance = [0.0] * 36
            pose_msg.pose.covariance[0] = 0.01  # x
            pose_msg.pose.covariance[7] = 0.01  # y
            pose_msg.pose.covariance[35] = 0.01  # yaw
            
            # 多次发布确保 AMCL 收到
            for _ in range(3):
                pose_msg.header.stamp = rospy.Time.now()
                self._initial_pose_pub.publish(pose_msg)
                rospy.sleep(0.1)
            
            # 3. 清除 costmap
            try:
                if hasattr(self, 'evaluator'):
                    if self.evaluator.clear_global_costmap:
                        self.evaluator.clear_global_costmap()
                    if self.evaluator.clear_local_costmap:
                        self.evaluator.clear_local_costmap()
            except:
                pass
            
            rospy.sleep(0.5)  # 等待位置更新生效
            rospy.loginfo("机器人已重置到初始位置 (0, 0, 0)")
            return True
        except Exception as e:
            rospy.logwarn(f"重置机器人位置失败: {e}")
            return False
    
    def objective(self, trial):
        """Optuna 目标函数"""
        rospy.loginfo(f"\n{'='*50}")
        rospy.loginfo(f"Trial {trial.number + 1}/{self.config.N_TRIALS}")
        rospy.loginfo(f"{'='*50}")
        
        # 0. 重置机器人位置
        self.reset_robot_pose()
        
        # 1. 采样参数
        params = self.define_search_space(trial)
        
        # 打印所有采样参数（验证参数确实在变化）
        rospy.loginfo(f"  [TEB速度] max_vel_x={params['teb_max_vel_x']:.3f}, max_vel_theta={params['teb_max_vel_theta']:.3f}")
        rospy.loginfo(f"  [TEB加速度] acc_lim_x={params['teb_acc_lim_x']:.3f}, acc_lim_theta={params['teb_acc_lim_theta']:.3f}")
        rospy.loginfo(f"  [TEB容差] xy_tol={params['teb_xy_goal_tolerance']:.4f}, yaw_tol={params['teb_yaw_goal_tolerance']:.3f}")
        rospy.loginfo(f"  [TEB障碍物] min_dist={params['teb_min_obstacle_dist']:.3f}, inflation={params['teb_inflation_dist']:.3f}")
        rospy.loginfo(f"  [TEB权重] obstacle={params['teb_weight_obstacle']:.2f}, viapoint={params['teb_weight_viapoint']:.2f}, time={params['teb_weight_optimaltime']:.3f}")
        rospy.loginfo(f"  [Costmap] inflation_radius={params['inflation_radius']:.4f}, cost_scaling={params['cost_scaling_factor']:.2f}")
        rospy.loginfo(f"  [频率] controller={params['controller_frequency']:.1f}Hz, planner={params['planner_frequency']:.2f}Hz")
        
        # 2. 应用参数到配置文件（保存到 YAML 作为备份）
        self.apply_params_to_yaml(params)
        
        # 3. 使用 dynamic_reconfigure 在线更新参数
        self.reload_params(params)
        
        # 4. 构建本次 trial 的目标点列表
        # 复制目标场景列表，避免修改原始配置
        scenarios_to_visit = list(self.config.TEST_SCENARIOS)
        
        # 如果启用随机顺序，打乱目标点访问顺序
        if self.config.RANDOMIZE_GOAL_ORDER:
            random.shuffle(scenarios_to_visit)
            goal_names = [s['name'] for s in scenarios_to_visit]
            rospy.loginfo(f"  随机目标顺序: {' -> '.join(goal_names)}")
        
        # 如果需要返回起点，在最后添加起始点
        if self.config.RETURN_TO_START:
            scenarios_to_visit.append(self.config.START_POINT)
            rospy.loginfo(f"  最后返回: {self.config.START_POINT['name']}")
        
        # 5. 评估所有场景（带剪枝的中间汇报）
        results = []
        total_weight_success = 0.0
        weighted_score = 0.0
        total_weight_all = sum(s['weight'] for s in scenarios_to_visit)
        failure_penalty_weight = 0.0
        stuck_count = 0  # 记录卡住次数
        
        for idx, scenario in enumerate(scenarios_to_visit):
            result = self.evaluate_scenario(scenario)
            results.append(result)
            
            if result['success']:
                weighted_score += result['score'] * result['weight']
                total_weight_success += result['weight']
            else:
                # 一旦任一场景失败，立即强制剪枝整个 trial
                failure_penalty_weight += result['weight']
                stuck_count += 1  # 失败视为卡住
                if total_weight_success > 0:
                    base_score_partial = weighted_score / total_weight_success
                else:
                    base_score_partial = 0.0

                success_rate_partial = sum(1 for r in results if r['success']) / len(results)
                normalized_failure_partial = failure_penalty_weight / max(total_weight_all, 1e-6)
                # 增强失败惩罚：基础惩罚 + 卡住次数惩罚
                stuck_penalty = stuck_count * 0.15  # 每次卡住额外扣0.15分
                interim_score = base_score_partial * 0.4 + success_rate_partial * 0.2 - normalized_failure_partial * 0.8 - stuck_penalty
                trial.report(interim_score, step=idx)
                rospy.loginfo(f"Trial {trial.number + 1} 在场景 {scenario['name']} 失败，强制剪枝 (得分 {interim_score:.4f}, 卡住{stuck_count}次)")
                raise optuna.TrialPruned()

            # ========== 剪枝：根据当前已经完成的场景计算一个临时得分 ==========
            if total_weight_success > 0:
                base_score_partial = weighted_score / total_weight_success
            else:
                base_score_partial = 0.0

            success_rate_partial = sum(1 for r in results if r['success']) / len(results)
            normalized_failure_partial = failure_penalty_weight / max(total_weight_all, 1e-6)
            # 更高层次惩罚：失败场景（尤其是高权重场景）显著拉低总分
            stuck_penalty = stuck_count * 0.15
            interim_score = base_score_partial * 0.4 + success_rate_partial * 0.2 - normalized_failure_partial * 0.8 - stuck_penalty

            # 向 Optuna 报告中间结果，并检查是否需要剪枝
            trial.report(interim_score, step=idx)
            if trial.should_prune():
                rospy.loginfo(f"Trial {trial.number + 1} 在场景 {scenario['name']} 被剪枝，中间得分 {interim_score:.4f}")
                raise optuna.TrialPruned()
        
        # 5. 计算最终得分
        if total_weight_success > 0:
            base_score = weighted_score / total_weight_success
        else:
            base_score = 0.0
        
        # 成功率与失败率
        success_rate = sum(1 for r in results if r['success']) / len(results)
        normalized_failure = failure_penalty_weight / max(total_weight_all, 1e-6)
        
        # 综合得分: 基础得分 + 成功率奖励 - 失败惩罚 - 卡住惩罚
        # 失败惩罚从 0.5 提升到 0.8，卡住每次额外扣 0.15
        stuck_penalty = stuck_count * 0.15
        final_score = base_score * 0.4 + success_rate * 0.2 - normalized_failure * 0.8 - stuck_penalty
        
        # 6. 记录结果
        self.trial_results.append({
            'trial': trial.number,
            'params': params.copy(),
            'score': final_score,
            'success_rate': success_rate,
            'results': results
        })
        
        # 7. 更新最佳结果
        if final_score > self.best_score:
            self.best_score = final_score
            self.best_params = params.copy()
            rospy.loginfo(f"🎉 新的最佳得分: {final_score:.4f}")
            self.save_best_params()
        
        rospy.loginfo(f"Trial {trial.number + 1} 最终得分: {final_score:.4f} (成功率: {success_rate*100:.1f}%)")
        
        return final_score
    
    def save_best_params(self):
        """保存最佳参数"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # 保存参数
        best_file = self.result_dir / f"best_params_{timestamp}.yaml"
        with open(best_file, 'w') as f:
            yaml.dump({
                'score': self.best_score,
                'params': self.best_params,
                'timestamp': timestamp
            }, f, default_flow_style=False)
        
        # 同时保存一个固定名称的最新最佳参数
        latest_file = self.result_dir / "best_params_latest.yaml"
        with open(latest_file, 'w') as f:
            yaml.dump({
                'score': self.best_score,
                'params': self.best_params,
                'timestamp': timestamp
            }, f, default_flow_style=False)
        
        rospy.loginfo(f"最佳参数已保存到: {best_file}")
    
    def save_study_results(self, study):
        """保存完整的优化结果"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # 保存所有 trial 结果
        results_file = self.result_dir / f"all_trials_{timestamp}.yaml"
        with open(results_file, 'w') as f:
            yaml.dump(self.trial_results, f, default_flow_style=False)
        
        # 保存优化历史
        history_file = self.result_dir / f"optimization_history_{timestamp}.csv"
        with open(history_file, 'w') as f:
            f.write("trial,score,success_rate\n")
            for r in self.trial_results:
                f.write(f"{r['trial']},{r['score']:.4f},{r['success_rate']:.4f}\n")
        
        rospy.loginfo(f"优化结果已保存到: {self.result_dir}")
    
    def run(self):
        """运行优化"""
        rospy.loginfo("=" * 60)
        rospy.loginfo("Optuna TPE 导航参数优化器")
        rospy.loginfo("=" * 60)
        
        # 初始化评估器
        self.evaluator = NavigationEvaluator()
        
        # 创建 Optuna study（带剪枝器 + SQLite 持久化）
        sampler = TPESampler(
            n_startup_trials=15,   # 增加初始随机采样，让 TPE 有更多数据学习
            multivariate=True,     # 启用多变量关系学习，更好地理解参数间的关联
            group=True,            # 分组采样，提高效率
            seed=42
        )

        pruner = MedianPruner(
            n_startup_trials=15,   # 前15个 trial 不剪枝，让 TPE 学到更多
            n_warmup_steps=1,      # 第一个场景失败就可以剪枝
            interval_steps=1       # 每完成 1 个场景检查一次
        )
        
        # 使用 SQLite 存储，让 study 有"记忆"
        db_path = self.result_dir / "optuna_study.db"
        storage = f"sqlite:///{db_path}"
        
        # 尝试加载已有的 study，如果不存在则创建新的
        try:
            study = optuna.load_study(
                study_name="nav_param_optimization",
                storage=storage,
                sampler=sampler,
                pruner=pruner
            )
            rospy.loginfo(f"加载已有 Study，已完成 {len(study.trials)} 个 trials")
        except KeyError:
            study = optuna.create_study(
                direction="maximize",
                sampler=sampler,
                pruner=pruner,
                study_name="nav_param_optimization",
                storage=storage
            )
            rospy.loginfo("创建新的 Study")
        
        # 运行优化
        try:
            study.optimize(
                self.objective,
                n_trials=self.config.N_TRIALS,
                show_progress_bar=True
            )
        except KeyboardInterrupt:
            rospy.loginfo("\n优化被用户中断")
        finally:
            # 保存结果
            self.save_study_results(study)
        
        # 输出最终结果
        rospy.loginfo("\n" + "=" * 60)
        rospy.loginfo("优化完成!")
        rospy.loginfo("=" * 60)
        rospy.loginfo(f"最佳得分: {study.best_value:.4f}")
        rospy.loginfo("最佳参数:")
        for key, value in study.best_params.items():
            rospy.loginfo(f"  {key}: {value}")
        
        # 应用最佳参数
        rospy.loginfo("\n正在应用最佳参数...")
        self.apply_params_to_yaml(study.best_params)
        rospy.loginfo("最佳参数已应用到配置文件")
        
        return study


def main():
    # 初始化 ROS 节点
    rospy.init_node('optuna_nav_optimizer', anonymous=True)
    
    # 从配置文件加载设置
    Config.load_from_yaml()
    
    # 打印测试场景和访问策略
    rospy.loginfo("=" * 50)
    rospy.loginfo("目标馆列表 (5个目标点):")
    for i, s in enumerate(Config.TEST_SCENARIOS):
        rospy.loginfo(f"  {i+1}. {s['name']}: ({s['goal'][0]:.3f}, {s['goal'][1]:.3f})")
    rospy.loginfo(f"起始点/返回点: {Config.START_POINT['name']}: ({Config.START_POINT['goal'][0]:.3f}, {Config.START_POINT['goal'][1]:.3f})")
    rospy.loginfo("-" * 50)
    rospy.loginfo(f"访问策略: 随机顺序={Config.RANDOMIZE_GOAL_ORDER}, 返回起点={Config.RETURN_TO_START}")
    rospy.loginfo("=" * 50)
    
    # 等待必要的服务
    rospy.loginfo("等待系统就绪...")
    rospy.sleep(2.0)
    
    # 创建并运行优化器
    optimizer = OptunaNavigationOptimizer()
    study = optimizer.run()
    
    rospy.loginfo("优化器退出")


if __name__ == '__main__':
    try:
        main()
    except rospy.ROSInterruptException:
        pass
