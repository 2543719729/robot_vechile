#include <ros/ros.h>
#include <actionlib/client/simple_action_client.h>
#include <move_base_msgs/MoveBaseAction.h>
#ifdef NAV_GOAL_WITH_AUDIO
#include <bobac3_audio/robot_tts.h>
#endif
#include <tf/transform_listener.h>
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
    {1.035, 1.109, -0.012, 1.000, "深圳", "深圳，中国的科创中心"},
    {1.063, 2.120, 0.013, 1.000, "上海", "上海，中国的经济中心"},
    {2.52, 0.15, 0.03, 0.99, "北京", "北京，中国的首都"},
    {2.48, 1.15, -0.026, 1.000, "广州", "广州，自古以来都是中国的商都"},//2.48,1.077
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
        ROS_WARN("TF查询失败: %s", ex.what());
        return false;
    }
}

double distanceToGoal(double curr_x, double curr_y, double goal_x, double goal_y) {
    return std::sqrt(std::pow(curr_x - goal_x, 2) + std::pow(curr_y - goal_y, 2));
}

bool speakDescription(ros::ServiceClient& tts_client, const std::string& text) {
#ifdef NAV_GOAL_WITH_AUDIO
    if (!tts_client.isValid()) return true;
    bobac3_audio::robot_tts srv;
    srv.request.text = text;
    srv.request.play = true;
    if (!tts_client.call(srv)) {
        ROS_WARN("调用 voice_tts 服务失败");
        return false;
    }
#else
    (void)tts_client;
    (void)text;
#endif
    return true;
}

// 导航到目标点，并在成功后计算与目标的距离
bool navigateToPoint(actionlib::SimpleActionClient<move_base_msgs::MoveBaseAction>& ac,
                     ros::ServiceClient& tts_client,
                     tf::TransformListener& tf_listener,
                     const Point& point) {
    ROS_INFO("========================================");
    ROS_INFO("导航目标：%s (%.2f, %.2f)", point.name.c_str(), point.x, point.y);

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

    if (success && ac.getState() == actionlib::SimpleClientGoalState::SUCCEEDED) {
        double curr_x, curr_y;
        if (getCurrentPosition(tf_listener, curr_x, curr_y)) {
            double dist = distanceToGoal(curr_x, curr_y, point.x, point.y);
            ROS_INFO("✓ 成功到达：%s", point.name.c_str());
            ROS_INFO("目标位置: (%.3f, %.3f)", point.x, point.y);
            ROS_INFO("实际位置: (%.3f, %.3f)", curr_x, curr_y);
            ROS_INFO("位置偏差: %.3f m (%.1f cm)", dist, dist * 100.0);
        } else {
            ROS_INFO("✓ 成功到达：%s (无法获取当前位置)", point.name.c_str());
        }
        ROS_INFO("介绍：%s", point.description.c_str());
        ROS_INFO("========================================\n");
        speakDescription(tts_client, point.description);
        return true;
    } else {
        ROS_WARN("✗ 导航失败！状态: %s", ac.getState().toString().c_str());
        ROS_INFO("========================================\n");
        ac.cancelGoal();
        return false;
    }
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
    ros::ServiceClient tts_client;
#ifdef NAV_GOAL_WITH_AUDIO
    ros::NodeHandle private_nh("~");
    bool enable_tts = false;
    private_nh.param("enable_tts", enable_tts, false);
    if (enable_tts) {
        tts_client = nh.serviceClient<bobac3_audio::robot_tts>("voice_tts");
    }
#endif

    actionlib::SimpleActionClient<move_base_msgs::MoveBaseAction> ac("move_base", true);
    tf::TransformListener tf_listener;

    cout << "\n========================================" << endl;
    cout << "    文本导航系统 - Text Navigation    " << endl;
    cout << "========================================" << endl;

    ROS_INFO("等待 move_base 服务器启动...");
    ac.waitForServer();
    ROS_INFO("move_base 服务器已连接！");

    showAvailablePoints();

    while (ros::ok()) {
        cout << "\n请输入导航目标：" << endl;
        cout << "  - 输入地点名称（深圳/上海/北京/广州/吉林）" << endl;
        cout << "  - 输入数字 1-5 选择对应地点" << endl;
        cout << "  - 输入 'list' 查看所有地点" << endl;
        cout << "  - 输入 'quit' 退出程序" << endl;
        cout << ">>> ";

        string input;
        if (!getline(cin, input)) break;

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
            navigateToPoint(ac, tts_client, tf_listener, nav_points[index]);
        } else {
            // 按名称查找
            for (int i = 0; i < 5; i++) {
                if (input.find(nav_points[i].name) != string::npos) {
                    found = true;
                    navigateToPoint(ac, tts_client, tf_listener, nav_points[i]);
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
