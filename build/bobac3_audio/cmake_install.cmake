# Install script for directory: /home/liyaxin075/Documents/robot_learning/src/bobac3_audio

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/bobac3_audio/srv" TYPE FILE FILES
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv"
    "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/bobac3_audio/cmake" TYPE FILE FILES "/home/liyaxin075/Documents/robot_learning/build/bobac3_audio/catkin_generated/installspace/bobac3_audio-msg-paths.cmake")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/home/liyaxin075/Documents/robot_learning/devel/include/bobac3_audio")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/roseus/ros" TYPE DIRECTORY FILES "/home/liyaxin075/Documents/robot_learning/devel/share/roseus/ros/bobac3_audio")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/common-lisp/ros" TYPE DIRECTORY FILES "/home/liyaxin075/Documents/robot_learning/devel/share/common-lisp/ros/bobac3_audio")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/gennodejs/ros" TYPE DIRECTORY FILES "/home/liyaxin075/Documents/robot_learning/devel/share/gennodejs/ros/bobac3_audio")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  execute_process(COMMAND "/usr/bin/python3" -m compileall "/home/liyaxin075/Documents/robot_learning/devel/lib/python3/dist-packages/bobac3_audio")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3/dist-packages" TYPE DIRECTORY FILES "/home/liyaxin075/Documents/robot_learning/devel/lib/python3/dist-packages/bobac3_audio")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/liyaxin075/Documents/robot_learning/build/bobac3_audio/catkin_generated/installspace/bobac3_audio.pc")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/bobac3_audio/cmake" TYPE FILE FILES "/home/liyaxin075/Documents/robot_learning/build/bobac3_audio/catkin_generated/installspace/bobac3_audio-msg-extras.cmake")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/bobac3_audio/cmake" TYPE FILE FILES
    "/home/liyaxin075/Documents/robot_learning/build/bobac3_audio/catkin_generated/installspace/bobac3_audioConfig.cmake"
    "/home/liyaxin075/Documents/robot_learning/build/bobac3_audio/catkin_generated/installspace/bobac3_audioConfig-version.cmake"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/bobac3_audio" TYPE FILE FILES "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/package.xml")
endif()

