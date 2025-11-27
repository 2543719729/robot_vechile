; Auto-generated. Do not edit!


(cl:in-package bobac3_msgs-msg)


;//! \htmlinclude car_cmd.msg.html

(cl:defclass <car_cmd> (roslisp-msg-protocol:ros-message)
  ((speed
    :reader speed
    :initarg :speed
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0))
   (been
    :reader been
    :initarg :been
    :type cl:fixnum
    :initform 0))
)

(cl:defclass car_cmd (<car_cmd>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <car_cmd>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'car_cmd)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-msg:<car_cmd> is deprecated: use bobac3_msgs-msg:car_cmd instead.")))

(cl:ensure-generic-function 'speed-val :lambda-list '(m))
(cl:defmethod speed-val ((m <car_cmd>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:speed-val is deprecated.  Use bobac3_msgs-msg:speed instead.")
  (speed m))

(cl:ensure-generic-function 'been-val :lambda-list '(m))
(cl:defmethod been-val ((m <car_cmd>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:been-val is deprecated.  Use bobac3_msgs-msg:been instead.")
  (been m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <car_cmd>) ostream)
  "Serializes a message object of type '<car_cmd>"
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'speed))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-double-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream)))
   (cl:slot-value msg 'speed))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'been)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'been)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <car_cmd>) istream)
  "Deserializes a message object of type '<car_cmd>"
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'speed) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'speed)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-double-float-bits bits))))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'been)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'been)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<car_cmd>)))
  "Returns string type for a message object of type '<car_cmd>"
  "bobac3_msgs/car_cmd")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'car_cmd)))
  "Returns string type for a message object of type 'car_cmd"
  "bobac3_msgs/car_cmd")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<car_cmd>)))
  "Returns md5sum for a message object of type '<car_cmd>"
  "5a353eb45570aedb9fa4844cc33fae72")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'car_cmd)))
  "Returns md5sum for a message object of type 'car_cmd"
  "5a353eb45570aedb9fa4844cc33fae72")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<car_cmd>)))
  "Returns full string definition for message of type '<car_cmd>"
  (cl:format cl:nil "float64[] speed~%uint16 been~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'car_cmd)))
  "Returns full string definition for message of type 'car_cmd"
  (cl:format cl:nil "float64[] speed~%uint16 been~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <car_cmd>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'speed) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     2
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <car_cmd>))
  "Converts a ROS message object to a list"
  (cl:list 'car_cmd
    (cl:cons ':speed (speed msg))
    (cl:cons ':been (been msg))
))
