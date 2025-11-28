# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "bobac3_msgs: 6 messages, 4 services")

set(MSG_I_FLAGS "-Ibobac3_msgs:/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg;-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg;-Igeometry_msgs:/opt/ros/noetic/share/geometry_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(bobac3_msgs_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg" NAME_WE)
add_custom_target(_bobac3_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_msgs" "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg" NAME_WE)
add_custom_target(_bobac3_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_msgs" "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg" NAME_WE)
add_custom_target(_bobac3_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_msgs" "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg" "geometry_msgs/Point"
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg" NAME_WE)
add_custom_target(_bobac3_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_msgs" "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg" "bobac3_msgs/joint:std_msgs/Header:geometry_msgs/Point"
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg" NAME_WE)
add_custom_target(_bobac3_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_msgs" "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg" "geometry_msgs/Point"
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg" NAME_WE)
add_custom_target(_bobac3_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_msgs" "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv" NAME_WE)
add_custom_target(_bobac3_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_msgs" "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv" NAME_WE)
add_custom_target(_bobac3_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_msgs" "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv" NAME_WE)
add_custom_target(_bobac3_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_msgs" "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv" NAME_WE)
add_custom_target(_bobac3_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_msgs" "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv" ""
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_cpp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_cpp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_cpp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg"
  "${MSG_I_FLAGS}"
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_cpp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_cpp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs
)

### Generating Services
_generate_srv_cpp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_cpp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_cpp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_cpp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs
)

### Generating Module File
_generate_module_cpp(bobac3_msgs
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(bobac3_msgs_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(bobac3_msgs_generate_messages bobac3_msgs_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_cpp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_cpp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_cpp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_cpp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_cpp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_cpp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_cpp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_cpp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_cpp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_cpp _bobac3_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bobac3_msgs_gencpp)
add_dependencies(bobac3_msgs_gencpp bobac3_msgs_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bobac3_msgs_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_eus(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_eus(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_eus(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg"
  "${MSG_I_FLAGS}"
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_eus(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_eus(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs
)

### Generating Services
_generate_srv_eus(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_eus(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_eus(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_eus(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs
)

### Generating Module File
_generate_module_eus(bobac3_msgs
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(bobac3_msgs_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(bobac3_msgs_generate_messages bobac3_msgs_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_eus _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_eus _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_eus _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_eus _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_eus _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_eus _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_eus _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_eus _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_eus _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_eus _bobac3_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bobac3_msgs_geneus)
add_dependencies(bobac3_msgs_geneus bobac3_msgs_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bobac3_msgs_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_lisp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_lisp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_lisp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg"
  "${MSG_I_FLAGS}"
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_lisp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_lisp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs
)

### Generating Services
_generate_srv_lisp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_lisp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_lisp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_lisp(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs
)

### Generating Module File
_generate_module_lisp(bobac3_msgs
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(bobac3_msgs_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(bobac3_msgs_generate_messages bobac3_msgs_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_lisp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_lisp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_lisp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_lisp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_lisp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_lisp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_lisp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_lisp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_lisp _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_lisp _bobac3_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bobac3_msgs_genlisp)
add_dependencies(bobac3_msgs_genlisp bobac3_msgs_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bobac3_msgs_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_nodejs(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_nodejs(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_nodejs(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg"
  "${MSG_I_FLAGS}"
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_nodejs(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_nodejs(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs
)

### Generating Services
_generate_srv_nodejs(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_nodejs(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_nodejs(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_nodejs(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs
)

### Generating Module File
_generate_module_nodejs(bobac3_msgs
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(bobac3_msgs_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(bobac3_msgs_generate_messages bobac3_msgs_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_nodejs _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_nodejs _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_nodejs _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_nodejs _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_nodejs _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_nodejs _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_nodejs _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_nodejs _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_nodejs _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_nodejs _bobac3_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bobac3_msgs_gennodejs)
add_dependencies(bobac3_msgs_gennodejs bobac3_msgs_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bobac3_msgs_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_py(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_py(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_py(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg"
  "${MSG_I_FLAGS}"
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_py(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs
)
_generate_msg_py(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs
)

### Generating Services
_generate_srv_py(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_py(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_py(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs
)
_generate_srv_py(bobac3_msgs
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs
)

### Generating Module File
_generate_module_py(bobac3_msgs
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(bobac3_msgs_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(bobac3_msgs_generate_messages bobac3_msgs_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_cmd.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_py _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/car_data.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_py _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/joint.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_py _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/skeleton.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_py _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/ar_pose.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_py _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/msg/neck_angle.msg" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_py _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetRelativeMove.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_py _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/SetCharge.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_py _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/track.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_py _bobac3_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_msgs/srv/Neck.srv" NAME_WE)
add_dependencies(bobac3_msgs_generate_messages_py _bobac3_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bobac3_msgs_genpy)
add_dependencies(bobac3_msgs_genpy bobac3_msgs_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bobac3_msgs_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_msgs
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(bobac3_msgs_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()
if(TARGET geometry_msgs_generate_messages_cpp)
  add_dependencies(bobac3_msgs_generate_messages_cpp geometry_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_msgs
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(bobac3_msgs_generate_messages_eus std_msgs_generate_messages_eus)
endif()
if(TARGET geometry_msgs_generate_messages_eus)
  add_dependencies(bobac3_msgs_generate_messages_eus geometry_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_msgs
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(bobac3_msgs_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()
if(TARGET geometry_msgs_generate_messages_lisp)
  add_dependencies(bobac3_msgs_generate_messages_lisp geometry_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_msgs
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(bobac3_msgs_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()
if(TARGET geometry_msgs_generate_messages_nodejs)
  add_dependencies(bobac3_msgs_generate_messages_nodejs geometry_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_msgs
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(bobac3_msgs_generate_messages_py std_msgs_generate_messages_py)
endif()
if(TARGET geometry_msgs_generate_messages_py)
  add_dependencies(bobac3_msgs_generate_messages_py geometry_msgs_generate_messages_py)
endif()
