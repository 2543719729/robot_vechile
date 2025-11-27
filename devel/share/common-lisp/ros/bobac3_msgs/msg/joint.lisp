; Auto-generated. Do not edit!


(cl:in-package bobac3_msgs-msg)


;//! \htmlinclude joint.msg.html

(cl:defclass <joint> (roslisp-msg-protocol:ros-message)
  ((joint_name
    :reader joint_name
    :initarg :joint_name
    :type cl:string
    :initform "")
   (joint_position
    :reader joint_position
    :initarg :joint_position
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (confidence
    :reader confidence
    :initarg :confidence
    :type cl:float
    :initform 0.0))
)

(cl:defclass joint (<joint>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <joint>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'joint)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-msg:<joint> is deprecated: use bobac3_msgs-msg:joint instead.")))

(cl:ensure-generic-function 'joint_name-val :lambda-list '(m))
(cl:defmethod joint_name-val ((m <joint>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:joint_name-val is deprecated.  Use bobac3_msgs-msg:joint_name instead.")
  (joint_name m))

(cl:ensure-generic-function 'joint_position-val :lambda-list '(m))
(cl:defmethod joint_position-val ((m <joint>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:joint_position-val is deprecated.  Use bobac3_msgs-msg:joint_position instead.")
  (joint_position m))

(cl:ensure-generic-function 'confidence-val :lambda-list '(m))
(cl:defmethod confidence-val ((m <joint>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:confidence-val is deprecated.  Use bobac3_msgs-msg:confidence instead.")
  (confidence m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <joint>) ostream)
  "Serializes a message object of type '<joint>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'joint_name))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'joint_name))
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'joint_position) ostream)
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'confidence))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <joint>) istream)
  "Deserializes a message object of type '<joint>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'joint_name) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'joint_name) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'joint_position) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'confidence) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<joint>)))
  "Returns string type for a message object of type '<joint>"
  "bobac3_msgs/joint")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'joint)))
  "Returns string type for a message object of type 'joint"
  "bobac3_msgs/joint")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<joint>)))
  "Returns md5sum for a message object of type '<joint>"
  "759c2dfdf04327dc9ad25824b6b8bf26")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'joint)))
  "Returns md5sum for a message object of type 'joint"
  "759c2dfdf04327dc9ad25824b6b8bf26")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<joint>)))
  "Returns full string definition for message of type '<joint>"
  (cl:format cl:nil "string joint_name~%geometry_msgs/Point joint_position~%float32 confidence~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'joint)))
  "Returns full string definition for message of type 'joint"
  (cl:format cl:nil "string joint_name~%geometry_msgs/Point joint_position~%float32 confidence~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <joint>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'joint_name))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'joint_position))
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <joint>))
  "Converts a ROS message object to a list"
  (cl:list 'joint
    (cl:cons ':joint_name (joint_name msg))
    (cl:cons ':joint_position (joint_position msg))
    (cl:cons ':confidence (confidence msg))
))
