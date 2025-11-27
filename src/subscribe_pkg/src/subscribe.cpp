#include "ros/ros.h"
#include "third_pkg/myTestMsg.h"
#include "third_pkg/myTestSrv.h"

// 话题回调：打印自定义消息内容
void chatterCallback(const third_pkg::myTestMsg::ConstPtr &msg)
{
    ROS_INFO("I heard-name:%s,age:%d,ishandsome:%d,salary:%f",
             msg->name.c_str(), msg->age, msg->handsome, msg->salary);
}

int main(int argc, char **argv)
{
    ros::init(argc, argv, "subscribe_node");
    ros::NodeHandle n;
    ros::Rate loop_rate(1);

    // 订阅 third_pkg_topic 话题
    ros::Subscriber sub =
        n.subscribe("third_pkg_topic", 1000, chatterCallback);

    // 创建 batteryStatus 服务客户端
    ros::ServiceClient client =
        n.serviceClient<third_pkg::myTestSrv>("batteryStatus");

    third_pkg::myTestSrv mySrv;
    // 填充服务请求字段：1 表示查询电量
    mySrv.request.index = 1;

    while (ros::ok())
    {
        if (client.call(mySrv))
        {
            ROS_WARN("Client Get Battery:%d", mySrv.response.result);
        }
        else
        {
            ROS_ERROR("Failed to call batteryStatus service");
            return 1;
        }

        ros::spinOnce();
        loop_rate.sleep();
    }

    return 0;
}
