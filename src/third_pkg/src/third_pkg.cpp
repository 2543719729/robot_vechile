#include "ros/ros.h"
#include "third_pkg/myTestMsg.h"//添加自定义消息的头文件
#include "third_pkg/myTestSrv.h"//添加自定义服务的头文件
static int battery = 100;
bool checkBattery(third_pkg::myTestSrv::Request &req,third_pkg::myTestSrv::Response &res)//服务回调函数
{
if(1 == req.index)
{
ROS_WARN("service sending response:[%d]",battery);
res.result = battery;
}
return battery;
}
int main(int argc,char **argv)
{
ros::init(argc,argv,"third_pkg");
ros::NodeHandle n;// 更新话题的消息格式为自定义的消息格式
ros::Publisher chatter_pub = n.advertise<third_pkg::myTestMsg>("third_pkg_topic",1000);
ros::ServiceServer service = n.advertiseService("batteryStatus",checkBattery);//服务端定义与初始化
ros::Rate loop_rate(2);//发送话题的频率(HZ)0.5秒发送一条，一次电量-1，所以一秒电量-2；
while(ros::ok())
{
battery--;
if(battery<10)battery=100;
third_pkg::myTestMsg msg;//声明一个自定义消息的对象
msg.name = "corvin";
msg.age = 20;
msg.handsome = true;
msg.salary = 123.45;
chatter_pub.publish(msg);//将消息发布到话题中
ros::spinOnce();
loop_rate.sleep();
}
return 0;
}
