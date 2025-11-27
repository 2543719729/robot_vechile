# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "bobac3_audio: 0 messages, 8 services")

set(MSG_I_FLAGS "-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(bobac3_audio_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv" NAME_WE)
add_custom_target(_bobac3_audio_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_audio" "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv" NAME_WE)
add_custom_target(_bobac3_audio_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_audio" "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv" NAME_WE)
add_custom_target(_bobac3_audio_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_audio" "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv" NAME_WE)
add_custom_target(_bobac3_audio_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_audio" "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv" NAME_WE)
add_custom_target(_bobac3_audio_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_audio" "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv" NAME_WE)
add_custom_target(_bobac3_audio_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_audio" "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv" NAME_WE)
add_custom_target(_bobac3_audio_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_audio" "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv" ""
)

get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv" NAME_WE)
add_custom_target(_bobac3_audio_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bobac3_audio" "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv" ""
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages

### Generating Services
_generate_srv_cpp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_cpp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_cpp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_cpp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_cpp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_cpp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_cpp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_cpp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_audio
)

### Generating Module File
_generate_module_cpp(bobac3_audio
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_audio
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(bobac3_audio_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(bobac3_audio_generate_messages bobac3_audio_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_cpp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_cpp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_cpp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_cpp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_cpp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_cpp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_cpp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_cpp _bobac3_audio_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bobac3_audio_gencpp)
add_dependencies(bobac3_audio_gencpp bobac3_audio_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bobac3_audio_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages

### Generating Services
_generate_srv_eus(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_audio
)
_generate_srv_eus(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_audio
)
_generate_srv_eus(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_audio
)
_generate_srv_eus(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_audio
)
_generate_srv_eus(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_audio
)
_generate_srv_eus(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_audio
)
_generate_srv_eus(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_audio
)
_generate_srv_eus(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_audio
)

### Generating Module File
_generate_module_eus(bobac3_audio
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_audio
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(bobac3_audio_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(bobac3_audio_generate_messages bobac3_audio_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_eus _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_eus _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_eus _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_eus _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_eus _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_eus _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_eus _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_eus _bobac3_audio_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bobac3_audio_geneus)
add_dependencies(bobac3_audio_geneus bobac3_audio_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bobac3_audio_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages

### Generating Services
_generate_srv_lisp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_lisp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_lisp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_lisp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_lisp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_lisp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_lisp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_audio
)
_generate_srv_lisp(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_audio
)

### Generating Module File
_generate_module_lisp(bobac3_audio
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_audio
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(bobac3_audio_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(bobac3_audio_generate_messages bobac3_audio_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_lisp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_lisp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_lisp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_lisp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_lisp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_lisp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_lisp _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_lisp _bobac3_audio_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bobac3_audio_genlisp)
add_dependencies(bobac3_audio_genlisp bobac3_audio_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bobac3_audio_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages

### Generating Services
_generate_srv_nodejs(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_audio
)
_generate_srv_nodejs(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_audio
)
_generate_srv_nodejs(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_audio
)
_generate_srv_nodejs(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_audio
)
_generate_srv_nodejs(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_audio
)
_generate_srv_nodejs(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_audio
)
_generate_srv_nodejs(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_audio
)
_generate_srv_nodejs(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_audio
)

### Generating Module File
_generate_module_nodejs(bobac3_audio
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_audio
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(bobac3_audio_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(bobac3_audio_generate_messages bobac3_audio_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_nodejs _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_nodejs _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_nodejs _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_nodejs _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_nodejs _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_nodejs _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_nodejs _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_nodejs _bobac3_audio_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bobac3_audio_gennodejs)
add_dependencies(bobac3_audio_gennodejs bobac3_audio_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bobac3_audio_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages

### Generating Services
_generate_srv_py(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_audio
)
_generate_srv_py(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_audio
)
_generate_srv_py(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_audio
)
_generate_srv_py(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_audio
)
_generate_srv_py(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_audio
)
_generate_srv_py(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_audio
)
_generate_srv_py(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_audio
)
_generate_srv_py(bobac3_audio
  "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_audio
)

### Generating Module File
_generate_module_py(bobac3_audio
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_audio
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(bobac3_audio_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(bobac3_audio_generate_messages bobac3_audio_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_iat.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_py _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_semanteme.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_py _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/robot_tts.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_py _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Collect.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_py _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Awake.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_py _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Control.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_py _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/Nav.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_py _bobac3_audio_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/liyaxin075/Documents/robot_learning/src/bobac3_audio/srv/up_sync.srv" NAME_WE)
add_dependencies(bobac3_audio_generate_messages_py _bobac3_audio_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bobac3_audio_genpy)
add_dependencies(bobac3_audio_genpy bobac3_audio_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bobac3_audio_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_audio)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bobac3_audio
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(bobac3_audio_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_audio)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bobac3_audio
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(bobac3_audio_generate_messages_eus std_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_audio)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bobac3_audio
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(bobac3_audio_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_audio)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bobac3_audio
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(bobac3_audio_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_audio)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_audio\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bobac3_audio
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(bobac3_audio_generate_messages_py std_msgs_generate_messages_py)
endif()
