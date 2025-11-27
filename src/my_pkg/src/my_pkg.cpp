#include "ros/ros.h"
#include "std_msgs/String.h"
#include <sstream>
#include "test_pkg/test_pkg.h" //自定义头文件

int main(int argc, char *argv[])
{
ros::init(argc, argv, "my_pkg");
ros::NodeHandle n;

ros::Publisher chatter_pub = n.advertise<std_msgs::String>("my_chatter", 1000);
ros::Rate loop_rate(10);
int count = INIT_COUNT;//调用了头文件中的宏定义

ROS_INFO("test_pkg version:%s,init count:%d",TEST_PKG_VER,INIT_COUNT);//将其他软件包头文件中声明的宏定义打印出来
while (ros::ok())
{
std_msgs::String msg;
std::stringstream ss;
ss << "my_pkg " << count;
msg.data = ss.str();
ROS_INFO("%s", msg.data.c_str());
chatter_pub.publish(msg);
ros::spinOnce();
loop_rate.sleep();
++count;
}
return 0;
}
