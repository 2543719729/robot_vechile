; Auto-generated. Do not edit!


(cl:in-package bobac3_msgs-msg)


;//! \htmlinclude neck_angle.msg.html

(cl:defclass <neck_angle> (roslisp-msg-protocol:ros-message)
  ((angle
    :reader angle
    :initarg :angle
    :type cl:fixnum
    :initform 0))
)

(cl:defclass neck_angle (<neck_angle>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <neck_angle>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'neck_angle)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-msg:<neck_angle> is deprecated: use bobac3_msgs-msg:neck_angle instead.")))

(cl:ensure-generic-function 'angle-val :lambda-list '(m))
(cl:defmethod angle-val ((m <neck_angle>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:angle-val is deprecated.  Use bobac3_msgs-msg:angle instead.")
  (angle m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <neck_angle>) ostream)
  "Serializes a message object of type '<neck_angle>"
  (cl:let* ((signed (cl:slot-value msg 'angle)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <neck_angle>) istream)
  "Deserializes a message object of type '<neck_angle>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'angle) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<neck_angle>)))
  "Returns string type for a message object of type '<neck_angle>"
  "bobac3_msgs/neck_angle")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'neck_angle)))
  "Returns string type for a message object of type 'neck_angle"
  "bobac3_msgs/neck_angle")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<neck_angle>)))
  "Returns md5sum for a message object of type '<neck_angle>"
  "ecd1f62d4afad57b40d43ebefe588fc8")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'neck_angle)))
  "Returns md5sum for a message object of type 'neck_angle"
  "ecd1f62d4afad57b40d43ebefe588fc8")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<neck_angle>)))
  "Returns full string definition for message of type '<neck_angle>"
  (cl:format cl:nil "int16 angle~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'neck_angle)))
  "Returns full string definition for message of type 'neck_angle"
  (cl:format cl:nil "int16 angle~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <neck_angle>))
  (cl:+ 0
     2
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <neck_angle>))
  "Converts a ROS message object to a list"
  (cl:list 'neck_angle
    (cl:cons ':angle (angle msg))
))
