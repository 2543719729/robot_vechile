#include <ros/ros.h>
#include <actionlib/client/simple_action_client.h>
#include <move_base_msgs/MoveBaseAction.h>
#include <robot_audio/robot_tts.h>
#include <tf/transform_listener.h>
#include <geometry_msgs/Twist.h>
#include <iostream>
#include <string>
#include <cstdlib>
#include <cmath>

using namespace std;

// 定义导航点结构体
struct Point {
    float x;
    float y;
    float z;
    float w;
    string name;
    string description;
};

// 预定义的5个导航点（与voice_nav.cpp相同）
struct Point nav_points[5] = {
    {1.055, 1.109, -0.012, 1.000, "深圳", "深圳，中国的科创中心"},
    {1.055, 2.120, 0.013, 1.000, "上海", "上海，中国的经济中心"},
    {2.53, 0.155, 0.03, 0.99, "北京", "北京，中国的首都"},
    {2.49, 1.150, -0.026, 1.000, "广州", "广州，自古以来都是中国的商都"},//2.48,1.077
    {2.48, 2.120, -0.032, 0.999, "吉林", "吉林，位于中国的东北是人参之都"}
};

bool getCurrentPosition(tf::TransformListener& tf_listener, double& x, double& y) {
    tf::StampedTransform transform;
    try {
        tf_listener.lookupTransform("map", "base_footprint", ros::Time(0), transform);
        x = transform.getOrigin().x();
        y = transform.getOrigin().y();
        return true;
    } catch (tf::TransformException& ex) {
        printf("TF查询失败: %s\n", ex.what());
        return false;
    }
}

double distanceToGoal(double curr_x, double curr_y, double goal_x, double goal_y) {
    return std::sqrt(std::pow(curr_x - goal_x, 2) + std::pow(curr_y - goal_y, 2));
}

// 精确导航参数配置
struct PreciseNavConfig {
    double trigger_distance = 0.1;      // 触发精确导航的距离阈值
    double target_tolerance = 0.01;     // 目标精度 (1cm)
    double max_linear_vel = 0.05;       // 最大线速度 (m/s) - 降低避免过冲
    double min_linear_vel = 0.015;      // 最小线速度 (m/s)
    double max_angular_vel = 0.2;       // 最大角速度 (rad/s) - 降低避免震荡
    double kp_linear = 0.5;             // 线速度P增益 - 降低
    double kp_angular = 0.8;            // 角速度P增益 - 降低
    double timeout = 20.0;              // 超时时间(秒) - 增加
    double angle_threshold = 0.3;       // 角度阈值(~17度)，小于此值才前进
};

PreciseNavConfig precise_config;

// 获取当前朝向角度
bool getCurrentYaw(tf::TransformListener& tf_listener, double& yaw) {
    tf::StampedTransform transform;
    try {
        tf_listener.lookupTransform("map", "base_footprint", ros::Time(0), transform);
        yaw = tf::getYaw(transform.getRotation());
        return true;
    } catch (tf::TransformException& ex) {
        printf("TF查询失败: %s\n", ex.what());
        return false;
    }
}

// 归一化角度到 [-pi, pi]
double normalizeAngle(double angle) {
    while (angle > M_PI) angle -= 2.0 * M_PI;
    while (angle < -M_PI) angle += 2.0 * M_PI;
    return angle;
}

// 精确导航函数：当距离目标点较近时，使用直接速度控制精确到达
bool preciseNavigation(ros::Publisher& cmd_vel_pub,
                       tf::TransformListener& tf_listener,
                       double goal_x, double goal_y,
                       const std::string& point_name) {
    printf("[精确导航] 启动精确定位模式 -> %s\n", point_name.c_str());
    printf("[精确导航] 目标精度: %.3f m\n", precise_config.target_tolerance);
    
    geometry_msgs::Twist cmd_vel;
    ros::Time start_time = ros::Time::now();
    ros::Rate rate(20);  // 20Hz控制频率
    
    int log_counter = 0;
    bool in_verify_phase = false;  // 是否进入验证阶段
    int verify_count = 0;
    const int verify_threshold = 20;  // 停止后验证20次（1秒）
    
    while (ros::ok()) {
        // 检查超时
        if ((ros::Time::now() - start_time).toSec() > precise_config.timeout) {
            printf("[精确导航] 超时! 停止精确导航\n");
            cmd_vel.linear.x = 0;
            cmd_vel.angular.z = 0;
            cmd_vel_pub.publish(cmd_vel);
            return false;
        }
        
        // 获取当前位置
        double curr_x, curr_y, curr_yaw;
        if (!getCurrentPosition(tf_listener, curr_x, curr_y) || 
            !getCurrentYaw(tf_listener, curr_yaw)) {
            printf("[精确导航] 无法获取位置，等待...\n");
            rate.sleep();
            continue;
        }
        
        // 计算到目标点的距离和方向
        double dx = goal_x - curr_x;
        double dy = goal_y - curr_y;
        double distance = std::sqrt(dx * dx + dy * dy);
        double target_angle = std::atan2(dy, dx);
        double angle_error = normalizeAngle(target_angle - curr_yaw);
        
        // 验证阶段：完全停止并多次检查距离
        if (in_verify_phase) {
            // 确保完全停止
            cmd_vel.linear.x = 0;
            cmd_vel.angular.z = 0;
            cmd_vel_pub.publish(cmd_vel);
            
            if (distance < precise_config.target_tolerance) {
                verify_count++;
                printf("[精确导航] 验证中 %d/%d, 距离: %.4fm\n", verify_count, verify_threshold, distance);
                if (verify_count >= verify_threshold) {
                    printf("[精确导航] >>> 精确到达确认! 最终距离: %.4f m (%.2f cm)\n", distance, distance * 100);
                    return true;
                }
            } else {
                // 验证失败，退出验证阶段继续调整
                printf("[精确导航] 验证失败，距离 %.4fm > %.4fm，继续调整\n", distance, precise_config.target_tolerance);
                in_verify_phase = false;
                verify_count = 0;
            }
            rate.sleep();
            continue;
        }
        
        // 检查是否可以进入验证阶段
        if (distance < precise_config.target_tolerance) {
            printf("[精确导航] 进入验证阶段，当前距离: %.4fm\n", distance);
            in_verify_phase = true;
            verify_count = 0;
            // 立即停止
            cmd_vel.linear.x = 0;
            cmd_vel.angular.z = 0;
            cmd_vel_pub.publish(cmd_vel);
            rate.sleep();
            continue;
        }
        
        // 计算控制指令
        double linear_vel = 0.0;
        double angular_vel = 0.0;
        
        // 距离越近，速度越慢
        double close_threshold = precise_config.target_tolerance * 3.0;  // 0.03m
        bool very_close = distance < close_threshold;
        double speed_scale = very_close ? 0.4 : (distance < 0.05 ? 0.6 : 1.0);
        
        // 选择前进还是后退：目标在后方时后退
        bool use_backward = std::abs(angle_error) > M_PI / 2.0;
        double effective_angle_error = use_backward ? normalizeAngle(angle_error + M_PI) : angle_error;
        
        // 策略：先旋转对准，再移动
        // 角度偏差大时，优先原地旋转
        if (std::abs(effective_angle_error) > precise_config.angle_threshold) {
            // 原地旋转对准目标
            angular_vel = precise_config.kp_angular * effective_angle_error * speed_scale;
            // 旋转时不移动，避免偏移
            linear_vel = 0.0;
        } else {
            // 角度OK，直线移动
            double move_speed = precise_config.kp_linear * distance * speed_scale;
            linear_vel = use_backward ? -move_speed : move_speed;
            // 移动时微调角度
            angular_vel = precise_config.kp_angular * effective_angle_error * 0.3 * speed_scale;
        }
        
        // 限制线速度
        double max_lin = precise_config.max_linear_vel * speed_scale;
        double min_lin = precise_config.min_linear_vel * speed_scale;
        if (linear_vel > max_lin) linear_vel = max_lin;
        if (linear_vel < -max_lin) linear_vel = -max_lin;
        if (linear_vel > 0 && linear_vel < min_lin) linear_vel = min_lin;
        if (linear_vel < 0 && linear_vel > -min_lin) linear_vel = -min_lin;
        
        // 限制角速度
        double max_ang = precise_config.max_angular_vel * speed_scale;
        if (angular_vel > max_ang) angular_vel = max_ang;
        if (angular_vel < -max_ang) angular_vel = -max_ang;
        
        cmd_vel.linear.x = linear_vel;
        cmd_vel.angular.z = angular_vel;
        cmd_vel_pub.publish(cmd_vel);
        
        if (++log_counter % 10 == 0) {
            const char* action = (linear_vel == 0.0) ? "[旋转]" : (use_backward ? "[后退]" : "[前进]");
            printf("[精确导航] 距离: %.4fm, 角度偏差: %.1f°, 速度: (%.3f, %.3f) %s%s\n",
                     distance, effective_angle_error * 180.0 / M_PI,
                     linear_vel, angular_vel, action,
                     very_close ? " [接近]" : "");
        }
        
        ros::spinOnce();
        rate.sleep();
    }
    
    return false;
}

bool speakDescription(ros::ServiceClient& tts_client, const std::string& text) {
    robot_audio::robot_tts srv;
    srv.request.text = text;
    srv.request.play = true;
    if (!tts_client.call(srv)) {
        printf("调用 voice_tts 服务失败\n");
        return false;
    }
    return true;
}

// 导航到目标点，并在成功后计算与目标的距离
bool navigateToPoint(actionlib::SimpleActionClient<move_base_msgs::MoveBaseAction>& ac, 
                     ros::ServiceClient& tts_client,
                     tf::TransformListener& tf_listener,
                     ros::Publisher& cmd_vel_pub,
                     const Point& point) {
    printf("========================================\n");
    printf("导航目标: %s (%.2f, %.2f)\n", point.name.c_str(), point.x, point.y);
    
    move_base_msgs::MoveBaseGoal goal;
    goal.target_pose.header.frame_id = "map";
    goal.target_pose.header.stamp = ros::Time::now();
    goal.target_pose.pose.position.x = point.x;
    goal.target_pose.pose.position.y = point.y;
    goal.target_pose.pose.orientation.z = point.z;
    goal.target_pose.pose.orientation.w = point.w;
    
    ac.sendGoal(goal);
    
    // 等待60秒超时
    bool success = ac.waitForResult(ros::Duration(60.0));
    
    double curr_x, curr_y;
    bool need_precise_nav = false;
    double final_distance = 0.0;
    
    if (success && ac.getState() == actionlib::SimpleClientGoalState::SUCCEEDED) {
        if (getCurrentPosition(tf_listener, curr_x, curr_y)) {
            final_distance = distanceToGoal(curr_x, curr_y, point.x, point.y);
            printf("[主导航] >>> 完成: %s\n", point.name.c_str());
            printf("[主导航] 目标位置: (%.3f, %.3f)\n", point.x, point.y);
            printf("[主导航] 实际位置: (%.3f, %.3f)\n", curr_x, curr_y);
            printf("[主导航] 位置偏差: %.3f m (%.1f cm)\n", final_distance, final_distance * 100.0);
            
            // 判断是否需要精确导航
            if (final_distance > precise_config.target_tolerance && 
                final_distance < precise_config.trigger_distance) {
                need_precise_nav = true;
            } else if (final_distance <= precise_config.target_tolerance) {
                printf("[主导航] 已达到目标精度，无需精确导航\n");
            }
        } else {
            printf("[主导航] >>> 完成: %s (无法获取当前位置)\n", point.name.c_str());
        }
    } else {
        // 主导航失败，检查是否在精确导航触发范围内
        printf("[主导航] 失败! 状态: %s\n", ac.getState().toString().c_str());
        ac.cancelGoal();
        
        if (getCurrentPosition(tf_listener, curr_x, curr_y)) {
            final_distance = distanceToGoal(curr_x, curr_y, point.x, point.y);
            printf("[主导航] 当前距离目标: %.3f m\n", final_distance);
            
            if (final_distance < precise_config.trigger_distance) {
                printf("[主导航] 距离在精确导航范围内，尝试精确导航\n");
                need_precise_nav = true;
            } else {
                printf("========================================\n");
                return false;
            }
        } else {
            printf("========================================\n");
            return false;
        }
    }
    
    // 执行精确导航
    if (need_precise_nav) {
        printf("----------------------------------------\n");
        bool precise_success = preciseNavigation(cmd_vel_pub, tf_listener, 
                                                  point.x, point.y, point.name);
        
        // 获取精确导航后的最终位置
        if (getCurrentPosition(tf_listener, curr_x, curr_y)) {
            final_distance = distanceToGoal(curr_x, curr_y, point.x, point.y);
            printf("[最终结果] 目标位置: (%.3f, %.3f)\n", point.x, point.y);
            printf("[最终结果] 实际位置: (%.3f, %.3f)\n", curr_x, curr_y);
            printf("[最终结果] 位置偏差: %.4f m (%.2f cm)\n", final_distance, final_distance * 100.0);
            
            if (final_distance <= precise_config.target_tolerance) {
                printf("[最终结果] >>> 达到目标精度!\n");
            } else {
                printf("[最终结果] 未能达到目标精度\n");
            }
        }
        
        if (!precise_success) {
            printf("[精确导航] 精确导航未能完全成功\n");
        }
    }
    
    printf("介绍: %s\n", point.description.c_str());
    printf("========================================\n");
    speakDescription(tts_client, point.description);
    return true;
}

// 显示可用的导航点
void showAvailablePoints() {
    cout << "\n可用的导航点：" << endl;
    cout << "----------------------------------------" << endl;
    for (int i = 0; i < 5; i++) {
        cout << (i+1) << ". " << nav_points[i].name 
             << " - 坐标(" << nav_points[i].x << ", " << nav_points[i].y << ")" << endl;
    }
    cout << "----------------------------------------" << endl;
}

int main(int argc, char** argv) {
    ros::init(argc, argv, "text_nav");
    ros::NodeHandle nh;
    ros::ServiceClient tts_client = nh.serviceClient<robot_audio::robot_tts>("voice_tts");
    ros::service::waitForService("voice_tts");
    
    actionlib::SimpleActionClient<move_base_msgs::MoveBaseAction> ac("move_base", true);
    tf::TransformListener tf_listener;
    
    // 创建速度控制发布器（用于精确导航）
    ros::Publisher cmd_vel_pub = nh.advertise<geometry_msgs::Twist>("cmd_vel", 10);
    
    // 从参数服务器读取精确导航参数（可选）
    nh.param("precise_nav/trigger_distance", precise_config.trigger_distance, 0.1);
    nh.param("precise_nav/target_tolerance", precise_config.target_tolerance, 0.01);
    nh.param("precise_nav/max_linear_vel", precise_config.max_linear_vel, 0.08);
    nh.param("precise_nav/min_linear_vel", precise_config.min_linear_vel, 0.02);
    nh.param("precise_nav/max_angular_vel", precise_config.max_angular_vel, 0.3);
    nh.param("precise_nav/kp_linear", precise_config.kp_linear, 0.8);
    nh.param("precise_nav/kp_angular", precise_config.kp_angular, 1.5);
    nh.param("precise_nav/timeout", precise_config.timeout, 15.0);
    
    printf("精确导航配置: 触发距离=%.2fm, 目标精度=%.3fm\n", 
             precise_config.trigger_distance, precise_config.target_tolerance);
    
    cout << "\n========================================" << endl;
    cout << "    文本导航系统 - Text Navigation    " << endl;
    cout << "========================================" << endl;
    
    printf("等待 move_base 服务器启动...\n");
    ac.waitForServer();
    printf("move_base 服务器已连接!\n");
    
    showAvailablePoints();
    
    while (ros::ok()) {
        cout << "\n请输入导航目标：" << endl;
        cout << "  - 输入地点名称（深圳/上海/北京/广州/吉林）" << endl;
        cout << "  - 输入数字 1-5 选择对应地点" << endl;
        cout << "  - 输入 'list' 查看所有地点" << endl;
        cout << "  - 输入 'quit' 退出程序" << endl;
        cout << ">>> ";
        
        string input;
        getline(cin, input);
        
        // 去除首尾空格
        input.erase(0, input.find_first_not_of(" \t\r\n"));
        input.erase(input.find_last_not_of(" \t\r\n") + 1);
        
        if (input.empty()) {
            continue;
        }
        
        // 退出命令
        if (input == "quit" || input == "exit" || input == "q") {
            cout << "\n退出文本导航系统。再见！" << endl;
            break;
        }
        
        // 显示列表
        if (input == "list" || input == "ls") {
            showAvailablePoints();
            continue;
        }
        
        // 查找匹配的导航点
        bool found = false;
        
        // 先尝试数字索引
        if (input.length() == 1 && input[0] >= '1' && input[0] <= '5') {
            int index = input[0] - '1';
            found = true;
            navigateToPoint(ac, tts_client, tf_listener, cmd_vel_pub, nav_points[index]);
        } else {
            // 按名称查找
            for (int i = 0; i < 5; i++) {
                if (input.find(nav_points[i].name) != string::npos) {
                    found = true;
                    navigateToPoint(ac, tts_client, tf_listener, cmd_vel_pub, nav_points[i]);
                    break;
                }
            }
        }
        
        if (!found) {
            cout << "❌ 未找到匹配的导航点：\"" << input << "\"" << endl;
            cout << "提示：请输入完整的地点名称或数字编号。" << endl;
        }
        
        ros::spinOnce();
    }
    
    return 0;
}
