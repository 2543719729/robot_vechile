; Auto-generated. Do not edit!


(cl:in-package bobac3_msgs-msg)


;//! \htmlinclude skeleton.msg.html

(cl:defclass <skeleton> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (joints
    :reader joints
    :initarg :joints
    :type (cl:vector bobac3_msgs-msg:joint)
   :initform (cl:make-array 0 :element-type 'bobac3_msgs-msg:joint :initial-element (cl:make-instance 'bobac3_msgs-msg:joint)))
   (success
    :reader success
    :initarg :success
    :type cl:boolean
    :initform cl:nil)
   (sleep_flag
    :reader sleep_flag
    :initarg :sleep_flag
    :type cl:boolean
    :initform cl:nil))
)

(cl:defclass skeleton (<skeleton>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <skeleton>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'skeleton)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-msg:<skeleton> is deprecated: use bobac3_msgs-msg:skeleton instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <skeleton>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:header-val is deprecated.  Use bobac3_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'joints-val :lambda-list '(m))
(cl:defmethod joints-val ((m <skeleton>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:joints-val is deprecated.  Use bobac3_msgs-msg:joints instead.")
  (joints m))

(cl:ensure-generic-function 'success-val :lambda-list '(m))
(cl:defmethod success-val ((m <skeleton>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:success-val is deprecated.  Use bobac3_msgs-msg:success instead.")
  (success m))

(cl:ensure-generic-function 'sleep_flag-val :lambda-list '(m))
(cl:defmethod sleep_flag-val ((m <skeleton>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:sleep_flag-val is deprecated.  Use bobac3_msgs-msg:sleep_flag instead.")
  (sleep_flag m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <skeleton>) ostream)
  "Serializes a message object of type '<skeleton>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'joints))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'joints))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'success) 1 0)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'sleep_flag) 1 0)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <skeleton>) istream)
  "Deserializes a message object of type '<skeleton>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'joints) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'joints)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'bobac3_msgs-msg:joint))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
    (cl:setf (cl:slot-value msg 'success) (cl:not (cl:zerop (cl:read-byte istream))))
    (cl:setf (cl:slot-value msg 'sleep_flag) (cl:not (cl:zerop (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<skeleton>)))
  "Returns string type for a message object of type '<skeleton>"
  "bobac3_msgs/skeleton")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'skeleton)))
  "Returns string type for a message object of type 'skeleton"
  "bobac3_msgs/skeleton")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<skeleton>)))
  "Returns md5sum for a message object of type '<skeleton>"
  "ad0f444058310ab55aac22b0856240d6")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'skeleton)))
  "Returns md5sum for a message object of type 'skeleton"
  "ad0f444058310ab55aac22b0856240d6")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<skeleton>)))
  "Returns full string definition for message of type '<skeleton>"
  (cl:format cl:nil "std_msgs/Header 	header~%bobac3_msgs/joint[] 	joints~%bool success~%bool sleep_flag~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: bobac3_msgs/joint~%string joint_name~%geometry_msgs/Point joint_position~%float32 confidence~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'skeleton)))
  "Returns full string definition for message of type 'skeleton"
  (cl:format cl:nil "std_msgs/Header 	header~%bobac3_msgs/joint[] 	joints~%bool success~%bool sleep_flag~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: bobac3_msgs/joint~%string joint_name~%geometry_msgs/Point joint_position~%float32 confidence~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <skeleton>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'joints) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
     1
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <skeleton>))
  "Converts a ROS message object to a list"
  (cl:list 'skeleton
    (cl:cons ':header (header msg))
    (cl:cons ':joints (joints msg))
    (cl:cons ':success (success msg))
    (cl:cons ':sleep_flag (sleep_flag msg))
))
