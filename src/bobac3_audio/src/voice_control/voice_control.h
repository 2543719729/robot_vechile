#include "ros/ros.h"
#include "bobac3_audio/Control.h"
#include "bobac3_audio/robot_tts.h"
#include <unistd.h>
#include <bobac3_msgs/SetRelativeMove.h>

class Control{
public:
    Control();
    ~Control();
private:
	ros::NodeHandle nh;
	ros::ServiceServer control_server;
	bool control_cb(bobac3_audio::Control::Request &req,bobac3_audio::Control::Response &res);
	ros::ServiceClient move_client;
	bobac3_msgs::SetRelativeMove move_srv;
	bobac3_audio::robot_tts tts_srv;
	ros::ServiceClient tts_client;
	ros::ServiceClient neck_client;
};
