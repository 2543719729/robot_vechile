#include <ros/ros.h>
#include <actionlib/client/simple_action_client.h>
#include <move_base_msgs/MoveBaseAction.h>

int main(int argc, char** argv)
{
  ros::init(argc,argv,"nav_multigoal");  
  ros::NodeHandle nh;  
  actionlib::SimpleActionClient<move_base_msgs::MoveBaseAction> ac("move_base",true);
  
  ROS_INFO("等待 move_base 服务器启动...");
  ac.waitForServer();
  ROS_INFO("move_base 服务器已连接！");
  
  // 定义目标点1（请根据实际地图修改坐标）
  move_base_msgs::MoveBaseGoal goal1;
  goal1.target_pose.header.frame_id = "map";  
  goal1.target_pose.header.stamp = ros::Time::now();  
  goal1.target_pose.pose.position.x = 2.0;  // 目标点x（米）
  goal1.target_pose.pose.position.y = 1.0;  // 目标点y（米）
  goal1.target_pose.pose.orientation.z = 0.0;  // 朝向
  goal1.target_pose.pose.orientation.w = 1.0;
  
  // 定义目标点2（请根据实际地图修改坐标）
  move_base_msgs::MoveBaseGoal goal2;
  goal2.target_pose.header.frame_id = "map";  
  goal2.target_pose.header.stamp = ros::Time::now();  
  goal2.target_pose.pose.position.x = 0.0;  // 目标点x（米）- 更保守的位置
  goal2.target_pose.pose.position.y = 0.0;  // 目标点y（米）- 更保守的位置
  goal2.target_pose.pose.orientation.z = 0.0;  // 朝向0度
  goal2.target_pose.pose.orientation.w = 1.0;
  
  int Num = 2;  // 巡检圈数
  for(int i=0; i<Num; i++)  
  {
    ROS_INFO("========== 开始第 %d 圈巡检 ==========", i+1);
    
    // 前往目标点1
    ROS_INFO("发送目标点1：(%.2f, %.2f)", 
             goal1.target_pose.pose.position.x, 
             goal1.target_pose.pose.position.y);
    ac.sendGoal(goal1);
    
    // 等待60秒超时
    bool success1 = ac.waitForResult(ros::Duration(60.0));
    if(success1 && ac.getState() == actionlib::SimpleClientGoalState::SUCCEEDED) {
      ROS_INFO("✓ 机器人到达目标点1");
    } else {
      ROS_WARN("✗ 目标点1失败！状态: %s", ac.getState().toString().c_str());
      ac.cancelGoal();
      continue;  // 跳过本次循环
    }
    
    // 前往目标点2
    ROS_INFO("发送目标点2：(%.2f, %.2f)", 
             goal2.target_pose.pose.position.x, 
             goal2.target_pose.pose.position.y);
    ac.sendGoal(goal2);
    
    // 等待60秒超时
    bool success2 = ac.waitForResult(ros::Duration(60.0));
    if(success2 && ac.getState() == actionlib::SimpleClientGoalState::SUCCEEDED) {
      ROS_INFO("✓ 机器人到达目标点2");
    } else {
      ROS_WARN("✗ 目标点2失败！状态: %s", ac.getState().toString().c_str());
      ac.cancelGoal();
      continue;  // 跳过本次循环
    }
    
    ROS_INFO("========== 完成第 %d 圈巡检 ==========\n", i+1);
  }
  
  ROS_INFO("所有巡检任务完成！");
  return 0;
}