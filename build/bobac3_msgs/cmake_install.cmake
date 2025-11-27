# Install script for directory: /home/liyaxin075/Documents/robot_learning/src/bobac3_msgs

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/liyaxin075/Documents/robot_learning/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/bobac3_msgs/msg" TYPE FILE FILES
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/bobac3_msgs/srv" TYPE FILE FILES
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/bobac3_msgs/cmake" TYPE FILE FILES "/home/liyaxin075/Documents/robot_learning/build/bobac3_msgs/catkin_generated/installspace/bobac3_msgs-msg-paths.cmake")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/home/liyaxin075/Documents/robot_learning/devel/include/bobac3_msgs")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/roseus/ros" TYPE DIRECTORY FILES "/home/liyaxin075/Documents/robot_learning/devel/share/roseus/ros/bobac3_msgs")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/common-lisp/ros" TYPE DIRECTORY FILES "/home/liyaxin075/Documents/robot_learning/devel/share/common-lisp/ros/bobac3_msgs")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/gennodejs/ros" TYPE DIRECTORY FILES "/home/liyaxin075/Documents/robot_learning/devel/share/gennodejs/ros/bobac3_msgs")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  execute_process(COMMAND "/usr/bin/python3" -m compileall "/home/liyaxin075/Documents/robot_learning/devel/lib/python3/dist-packages/bobac3_msgs")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages" TYPE DIRECTORY FILES "/home/liyaxin075/Documents/robot_learning/devel/lib/python3/dist-packages/bobac3_msgs")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/liyaxin075/Documents/robot_learning/build/bobac3_msgs/catkin_generated/installspace/bobac3_msgs.pc")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/bobac3_msgs/cmake" TYPE FILE FILES "/home/liyaxin075/Documents/robot_learning/build/bobac3_msgs/catkin_generated/installspace/bobac3_msgs-msg-extras.cmake")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/bobac3_msgs/cmake" TYPE FILE FILES
    "/home/liyaxin075/Documents/robot_learning/build/bobac3_msgs/catkin_generated/installspace/bobac3_msgsConfig.cmake"
    "/home/liyaxin075/Documents/robot_learning/build/bobac3_msgs/catkin_generated/installspace/bobac3_msgsConfig-version.cmake"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/bobac3_msgs" TYPE FILE FILES "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/package.xml")
endif()

