#include <ros/ros.h>
#include <actionlib/client/simple_action_client.h>
#include <move_base_msgs/MoveBaseAction.h>

int main(int argc, char** argv)
{
  ros::init(argc,argv,"nav_goal");//ros初始化
  ros::NodeHandle nh;//定义句柄
  actionlib::SimpleActionClient<move_base_msgs::MoveBaseAction> ac("move_base",true);//定义一个acition客户端 ，用于发送机器人要到达的目标
  ac.waitForServer();//等待服务开启
  move_base_msgs::MoveBaseGoal goal;//定义一个存储目标的变量
  goal.target_pose.header.frame_id = "map";
  goal.target_pose.header.stamp = ros::Time::now();
  goal.target_pose.pose.position.x = 2.0;//目标点x（米）- 请根据实际地图修改
  goal.target_pose.pose.position.y = 0.0;//目标点y（米）- 请根据实际地图修改
  goal.target_pose.pose.orientation.z = 0.0;//朝向0度（东向）
  goal.target_pose.pose.orientation.w = 1.0;//四元数归一化值
  ac.sendGoal(goal);//发送目标
  while(!(ac.getState()==actionlib::SimpleClientGoalState::SUCCEEDED))
  {
    usleep(10000*50);
  }//等待机器人执行完成
  ROS_INFO("机器人到达目标点");
  
  return 0;
}
