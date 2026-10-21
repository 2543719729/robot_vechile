cmake_minimum_required(VERSION 3.0.2)
project(robot_vechile_workspace)

# A portable catkin workspace entry point; do not commit /opt/ros symlinks.
set(CATKIN_TOPLEVEL TRUE)
find_package(catkin REQUIRED NO_POLICY_SCOPE)
catkin_workspace()
