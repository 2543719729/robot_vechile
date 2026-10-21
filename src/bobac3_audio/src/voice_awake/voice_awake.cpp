#include <ros/ros.h>
#include <bobac3_audio/Awake.h>

bool awake_cb(bobac3_audio::Awake::Request &req, bobac3_audio::Awake::Response &res){
  if(req.text.find("元宝") != std::string::npos){
    res.awake_flag= true;
  }
  else res.awake_flag = false;
  return true;

}

int main(int argc, char* argv[])
{
  /*初始化ros节点*/
  ros::init(argc, argv, "voice_awake");
  /*定义节点句柄*/
  ros::NodeHandle nh;
  ros::ServiceServer iat_server = nh.advertiseService("voice_awake", awake_cb);
  ros::spin();
  return 0;
}
