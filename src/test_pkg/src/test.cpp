#include "ros/ros.h"
#include "std_msgs/String.h"
#include "test_pkg/test_pkg.h" //自定义头文件
#include <sstream>
int addTwoNum(int a,int b)
{
return a+b;
}//头文件函数实现部分
int main(int argc, char *argv[])
{
ros::init(argc, argv, "talker");//这个名字是给系统看的
ros::NodeHandle n;
ros::Publisher chatter_pub = n.advertise <std_msgs::String >("chatter", 1000);
ros::Rate loop_rate(10);
int count = INIT_COUNT;//调用了头文件中的宏定义
ROS_INFO("test_pkg version:%s",TEST_PKG_VER);
while (ros::ok())
{
std_msgs::String msg;
std::stringstream ss;
ss << "hello world " << count;
msg.data = ss.str();
ROS_INFO("%s", msg.data.c_str());chatter_pub.publish(msg);
ros::spinOnce();
loop_rate.sleep();
++count;
}
return 0;
}


