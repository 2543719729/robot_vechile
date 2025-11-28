#include <ros/ros.h>
#include <robot_audio/robot_iat.h>
#include <robot_audio/Collect.h>
#include <robot_audio/robot_tts.h>
#include <actionlib/client/simple_action_client.h>
#include <move_base_msgs/MoveBaseAction.h>
#include <tf/transform_listener.h>
#include <geometry_msgs/Twist.h>
#include <iostream>
#include <string>
#include <cmath>

using namespace std;

// 定义导航点结构体
struct Point {
    float x;      // x坐标
    float y;      // y坐标
    float z;      // 姿态z (四元数)
    float w;      // 姿态w (四元数)
    string name;  // 地点名字
    string present; // 介绍语
};

// 预定义的5个导航点（与text_nav.cpp坐标完全相同）
struct Point m_point[5] = {
    {1.045, 1.109, -0.012, 1.000, "深圳馆", "深圳是中国的科创中心"},
    {1.045, 2.120, 0.013, 1.000, "上海馆", "上海是中国的经济中心"},
    {2.53, 0.155, 0.03, 0.99, "北京馆", "北京是中国的首都，政治中心"},
    {2.49, 1.150, -0.026, 1.000, "广州馆", "广州自古都是我国的商业之都"},
    {2.48, 2.120, -0.032, 0.999, "吉林馆", "吉林位于我国东北是人参之都"}
};

// 充电点坐标
struct Point charging_point = {
    0.4185, 2.1023, -0.7463, 0.6656, "充电点", "已到达充电点，开始充电"
};

// 导览顺序：吉林->上海->北京->广州->深圳
int tour_order[5] = {4, 1, 2, 3, 0};  // 对应 吉林馆、上海馆、北京馆、广州馆、深圳馆

// 精确导航参数配置
struct PreciseNavConfig {
    double trigger_distance = 0.1;      // 触发精确导航的距离阈值
    double target_tolerance = 0.01;     // 目标精度 (1cm)
    double max_linear_vel = 0.05;       // 最大线速度 (m/s)
    double min_linear_vel = 0.015;      // 最小线速度 (m/s)
    double max_angular_vel = 0.2;       // 最大角速度 (rad/s)
    double kp_linear = 0.5;             // 线速度P增益
    double kp_angular = 0.8;            // 角速度P增益
    double timeout = 20.0;              // 超时时间(秒)
    double angle_threshold = 0.3;       // 角度阈值(~17度)
};

PreciseNavConfig precise_config;

typedef actionlib::SimpleActionClient<move_base_msgs::MoveBaseAction> MoveBaseClient;

class VoiceNavigation {
public:
    VoiceNavigation();
    void run();  // 主循环
    
private:
    ros::NodeHandle nh;
    ros::ServiceClient collect_client;
    ros::ServiceClient dictation_client;
    ros::ServiceClient tts_client;
    ros::Publisher cmd_vel_pub;
    MoveBaseClient* ac;
    tf::TransformListener tf_listener;
    
    // 出发点位置
    double start_x, start_y, start_z, start_w;
    bool has_start_position;
    
    // 语音交互函数
    string voiceCollect();
    string voiceDictation(const string& filename);
    void voiceTTS(const string& text);
    
    // 导航函数
    bool navigateToPoint(const Point& point, bool announce = true);
    bool navigateToPosition(double x, double y, double z, double w, const string& name);
    bool preciseNavigation(double goal_x, double goal_y, const string& point_name);
    
    // 辅助函数
    bool getCurrentPosition(double& x, double& y);
    bool getCurrentYaw(double& yaw);
    double distanceToGoal(double curr_x, double curr_y, double goal_x, double goal_y);
    double normalizeAngle(double angle);
    void saveStartPosition();
    
    // 任务函数
    void tourAllMuseums();      // 任务一：参观一圈
    void navigateToMuseum(const string& museum_name);  // 任务二：指定位置导览
    void navigateToShenzhenWithCharging();  // 任务三：深圳馆+回原点+充电
};

VoiceNavigation::VoiceNavigation() : has_start_position(false) {
    collect_client = nh.serviceClient<robot_audio::Collect>("voice_collect");
    dictation_client = nh.serviceClient<robot_audio::robot_iat>("voice_iat");
    tts_client = nh.serviceClient<robot_audio::robot_tts>("voice_tts");
    cmd_vel_pub = nh.advertise<geometry_msgs::Twist>("cmd_vel", 10);
    
    ac = new MoveBaseClient("move_base", true);
    
    ROS_INFO("等待 voice_collect 服务...");
    ros::service::waitForService("voice_collect");
    ROS_INFO("voice_collect 服务已就绪");
    
    ROS_INFO("等待 move_base 服务器 (最多等待30秒)...");
    if (!ac->waitForServer(ros::Duration(30.0))) {
        ROS_WARN("move_base 服务器未启动! 请先启动导航: roslaunch bobac3_navigation demo_nav_2d.launch");
        ROS_WARN("语音导航功能将不可用，但语音识别仍可运行");
    } else {
        ROS_INFO("move_base 服务器已连接");
    }
    
    // 等待TF可用
    ros::Duration(1.0).sleep();
    
    // 从参数服务器读取精确导航参数（与 text_nav.cpp 保持一致）
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
    
    // 保存出发点位置
    saveStartPosition();
}

string VoiceNavigation::voiceCollect() {
    robot_audio::Collect srv;
    srv.request.collect_flag = 1;
    if (collect_client.call(srv)) {
        return srv.response.voice_filename;
    }
    return "";
}

string VoiceNavigation::voiceDictation(const string& filename) {
    ros::service::waitForService("voice_iat");
    robot_audio::robot_iat srv;
    srv.request.audiopath = filename;
    if (dictation_client.call(srv)) {
        return srv.response.text;
    }
    return "";
}

void VoiceNavigation::voiceTTS(const string& text) {
    ros::service::waitForService("voice_tts");
    robot_audio::robot_tts srv;
    srv.request.text = text;
    if (tts_client.call(srv)) {
        string cmd = "play " + srv.response.audiopath;
        system(cmd.c_str());
        sleep(1);
    }
}

bool VoiceNavigation::getCurrentPosition(double& x, double& y) {
    tf::StampedTransform transform;
    try {
        tf_listener.lookupTransform("map", "base_footprint", ros::Time(0), transform);
        x = transform.getOrigin().x();
        y = transform.getOrigin().y();
        return true;
    } catch (tf::TransformException& ex) {
        ROS_WARN("TF查询失败: %s", ex.what());
        return false;
    }
}

bool VoiceNavigation::getCurrentYaw(double& yaw) {
    tf::StampedTransform transform;
    try {
        tf_listener.lookupTransform("map", "base_footprint", ros::Time(0), transform);
        yaw = tf::getYaw(transform.getRotation());
        return true;
    } catch (tf::TransformException& ex) {
        return false;
    }
}

double VoiceNavigation::distanceToGoal(double curr_x, double curr_y, double goal_x, double goal_y) {
    return sqrt(pow(curr_x - goal_x, 2) + pow(curr_y - goal_y, 2));
}

double VoiceNavigation::normalizeAngle(double angle) {
    while (angle > M_PI) angle -= 2.0 * M_PI;
    while (angle < -M_PI) angle += 2.0 * M_PI;
    return angle;
}

void VoiceNavigation::saveStartPosition() {
    // 固定返回起始位置
    start_x = 0.030863063838223354;
    start_y = 0.012025865218924424;
    start_z = 0.0;
    start_w = 1.0;
    has_start_position = true;
    ROS_INFO("出发点位置固定为: (%.6f, %.6f)", start_x, start_y);
}

bool VoiceNavigation::preciseNavigation(double goal_x, double goal_y, const string& point_name) {
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
        if (!getCurrentPosition(curr_x, curr_y) ||
            !getCurrentYaw(curr_yaw)) {
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
                    printf("[精确导航] >>> 精确到达确认! 最终距离: %.4f m (%.2f cm)\n",
                           distance, distance * 100);
                    return true;
                }
            } else {
                // 验证失败，退出验证阶段继续调整
                printf("[精确导航] 验证失败，距离 %.4fm > %.4fm，继续调整\n",
                       distance, precise_config.target_tolerance);
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

bool VoiceNavigation::navigateToPosition(double x, double y, double z, double w, const string& name) {
    printf("========================================\n");
    printf("导航目标: %s (%.2f, %.2f)\n", name.c_str(), x, y);
    
    move_base_msgs::MoveBaseGoal goal;
    goal.target_pose.header.frame_id = "map";
    goal.target_pose.header.stamp = ros::Time::now();
    goal.target_pose.pose.position.x = x;
    goal.target_pose.pose.position.y = y;
    goal.target_pose.pose.orientation.z = z;
    goal.target_pose.pose.orientation.w = w;
    
    ac->sendGoal(goal);
    
    // 等待60秒超时
    bool success = ac->waitForResult(ros::Duration(60.0));
    
    double curr_x, curr_y;
    bool need_precise_nav = false;
    double final_distance = 0.0;
    
    if (success && ac->getState() == actionlib::SimpleClientGoalState::SUCCEEDED) {
        if (getCurrentPosition(curr_x, curr_y)) {
            final_distance = distanceToGoal(curr_x, curr_y, x, y);
            printf("[主导航] >>> 完成: %s\n", name.c_str());
            printf("[主导航] 目标位置: (%.3f, %.3f)\n", x, y);
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
            printf("[主导航] >>> 完成: %s (无法获取当前位置)\n", name.c_str());
        }
    } else {
        // 主导航失败，检查是否在精确导航触发范围内
        printf("[主导航] 失败! 状态: %s\n", ac->getState().toString().c_str());
        ac->cancelGoal();
        
        if (getCurrentPosition(curr_x, curr_y)) {
            final_distance = distanceToGoal(curr_x, curr_y, x, y);
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
        bool precise_success = preciseNavigation(x, y, name);
        
        // 获取精确导航后的最终位置
        if (getCurrentPosition(curr_x, curr_y)) {
            final_distance = distanceToGoal(curr_x, curr_y, x, y);
            printf("[最终结果] 目标位置: (%.3f, %.3f)\n", x, y);
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
    
    printf("========================================\n");
    return true;
}

bool VoiceNavigation::navigateToPoint(const Point& point, bool announce) {
    bool success = navigateToPosition(point.x, point.y, point.z, point.w, point.name);
    if (success && announce) {
        voiceTTS(point.present);
    }
    return success;
}

void VoiceNavigation::tourAllMuseums() {
    ROS_INFO("========== 开始参观导览 ==========");
    voiceTTS("好的");
    
    // 保存当前位置为出发点
    saveStartPosition();
    
    // 按顺序参观所有场馆: 吉林->上海->北京->广州->深圳
    for (int i = 0; i < 5; i++) {
        int idx = tour_order[i];
        ROS_INFO("参观第 %d 站: %s", i + 1, m_point[idx].name.c_str());
        navigateToPoint(m_point[idx], true);
    }
    
    // 返回出发点
    ROS_INFO("返回出发点...");
    voiceTTS("参观结束，返回出发点");
    navigateToPosition(start_x, start_y, start_z, start_w, "出发点");
    voiceTTS("已返回出发点");
    ROS_INFO("========== 导览完成 ==========");
}

void VoiceNavigation::navigateToMuseum(const string& museum_name) {
    for (int i = 0; i < 5; i++) {
        if (museum_name.find(m_point[i].name) != string::npos ||
            m_point[i].name.find(museum_name) != string::npos) {
            // 找到匹配的场馆
            string response = "好的，这就带您去" + m_point[i].name;
            voiceTTS(response);
            
            // 保存出发点
            saveStartPosition();
            
            // 导航到目标
            navigateToPoint(m_point[i], true);
            return;
        }
    }
    
    // 未找到匹配的场馆
    voiceTTS("抱歉，没有找到您说的场馆");
}

void VoiceNavigation::navigateToShenzhenWithCharging() {
    ROS_INFO("========== 深圳馆导览+充电任务 ==========");
    
    // 保存出发点（原点）
    saveStartPosition();
    
    // 第一步：导航到深圳馆
    voiceTTS("好的，这就带您去深圳馆");
    ROS_INFO("第一步：导航到深圳馆");
    navigateToPoint(m_point[0], true);  // m_point[0] 是深圳馆，播报介绍
    
    // 第二步：返回原点
    ROS_INFO("第二步：返回原点");
    voiceTTS("参观结束，返回出发点");
    navigateToPosition(start_x, start_y, start_z, start_w, "原点");
    voiceTTS("已返回原点");
    
    // 第三步：导航到充电点
    ROS_INFO("第三步：导航到充电点");
    voiceTTS("现在前往充电点");
    ros::Duration(2.0).sleep();  // 等待语音播报完成
    bool success = navigateToPosition(charging_point.x, charging_point.y, 
                                       charging_point.z, charging_point.w, 
                                       charging_point.name);
    
    // 到达充电点后停止并播报
    if (success) {
        // 确保机器人完全停止
        geometry_msgs::Twist stop_cmd;
        stop_cmd.linear.x = 0;
        stop_cmd.linear.y = 0;
        stop_cmd.angular.z = 0;
        cmd_vel_pub.publish(stop_cmd);
        
        ROS_INFO("已到达充电点，机器人停止");
        ros::Duration(0.5).sleep();  // 等待停止稳定
        voiceTTS(charging_point.present);  // "已到达充电点，开始充电"
        ros::Duration(3.0).sleep();  // 等待语音播报完成
    } else {
        voiceTTS("导航到充电点失败");
        ros::Duration(2.0).sleep();
    }
    
    ROS_INFO("========== 任务完成 ==========");
}

void VoiceNavigation::run() {
    ROS_INFO("语音导航系统已启动，等待语音指令...");
    
    while (ros::ok()) {
        // 采集语音
        string audio_file = voiceCollect();
        if (audio_file.empty()) continue;
        
        // 语音识别
        string text = voiceDictation(audio_file);
        if (text.empty()) continue;
        
        ROS_INFO("识别结果: %s", text.c_str());
        
        // 任务一: 整体导览 - "带我参观一圈"
        if (text.find("参观") != string::npos && text.find("一圈") != string::npos) {
            tourAllMuseums();
            continue;
        }
        
        // 任务二: 深圳馆特殊处理 - 导航+回原点+充电
        if ((text.find("深圳") != string::npos) && 
            (text.find("我要到") != string::npos || text.find("我要去") != string::npos ||
             text.find("带我去") != string::npos || text.find("导航到") != string::npos ||
             text.find("导航去") != string::npos || text.find("去") != string::npos)) {
            navigateToShenzhenWithCharging();
            continue;
        }
        
        // 任务三: 其他场馆导览 - "我要到XX馆"
        if (text.find("我要到") != string::npos || text.find("我要去") != string::npos ||
            text.find("带我去") != string::npos || text.find("导航到") != string::npos ||
            text.find("导航去") != string::npos || text.find("去") != string::npos) {
            // 检查是否包含场馆名称
            for (int i = 0; i < 5; i++) {
                // 匹配 "吉林"、"吉林馆" 等
                string short_name = m_point[i].name.substr(0, m_point[i].name.length() - 3); // 去掉"馆"
                if (text.find(m_point[i].name) != string::npos ||
                    text.find(short_name) != string::npos) {
                    navigateToMuseum(m_point[i].name);
                    break;
                }
            }
            continue;
        }
        
        ros::spinOnce();
    }
}

int main(int argc, char** argv) {
    ros::init(argc, argv, "voice_nav");
    
    VoiceNavigation nav;
    nav.run();
    
    return 0;
}
