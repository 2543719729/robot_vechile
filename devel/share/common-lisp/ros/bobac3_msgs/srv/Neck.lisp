; Auto-generated. Do not edit!


(cl:in-package bobac3_msgs-srv)


;//! \htmlinclude Neck-request.msg.html

(cl:defclass <Neck-request> (roslisp-msg-protocol:ros-message)
  ((angle
    :reader angle
    :initarg :angle
    :type cl:fixnum
    :initform 0))
)

(cl:defclass Neck-request (<Neck-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Neck-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Neck-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-srv:<Neck-request> is deprecated: use bobac3_msgs-srv:Neck-request instead.")))

(cl:ensure-generic-function 'angle-val :lambda-list '(m))
(cl:defmethod angle-val ((m <Neck-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-srv:angle-val is deprecated.  Use bobac3_msgs-srv:angle instead.")
  (angle m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Neck-request>) ostream)
  "Serializes a message object of type '<Neck-request>"
  (cl:let* ((signed (cl:slot-value msg 'angle)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Neck-request>) istream)
  "Deserializes a message object of type '<Neck-request>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'angle) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Neck-request>)))
  "Returns string type for a service object of type '<Neck-request>"
  "bobac3_msgs/NeckRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Neck-request)))
  "Returns string type for a service object of type 'Neck-request"
  "bobac3_msgs/NeckRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Neck-request>)))
  "Returns md5sum for a message object of type '<Neck-request>"
  "a4c3e5c0a24d8ee61cbbe52751e76b37")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Neck-request)))
  "Returns md5sum for a message object of type 'Neck-request"
  "a4c3e5c0a24d8ee61cbbe52751e76b37")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Neck-request>)))
  "Returns full string definition for message of type '<Neck-request>"
  (cl:format cl:nil "int16 angle~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Neck-request)))
  "Returns full string definition for message of type 'Neck-request"
  (cl:format cl:nil "int16 angle~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Neck-request>))
  (cl:+ 0
     2
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Neck-request>))
  "Converts a ROS message object to a list"
  (cl:list 'Neck-request
    (cl:cons ':angle (angle msg))
))
;//! \htmlinclude Neck-response.msg.html

(cl:defclass <Neck-response> (roslisp-msg-protocol:ros-message)
  ((result
    :reader result
    :initarg :result
    :type cl:string
    :initform ""))
)

(cl:defclass Neck-response (<Neck-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Neck-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Neck-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-srv:<Neck-response> is deprecated: use bobac3_msgs-srv:Neck-response instead.")))

(cl:ensure-generic-function 'result-val :lambda-list '(m))
(cl:defmethod result-val ((m <Neck-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-srv:result-val is deprecated.  Use bobac3_msgs-srv:result instead.")
  (result m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Neck-response>) ostream)
  "Serializes a message object of type '<Neck-response>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'result))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'result))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Neck-response>) istream)
  "Deserializes a message object of type '<Neck-response>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'result) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'result) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Neck-response>)))
  "Returns string type for a service object of type '<Neck-response>"
  "bobac3_msgs/NeckResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Neck-response)))
  "Returns string type for a service object of type 'Neck-response"
  "bobac3_msgs/NeckResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Neck-response>)))
  "Returns md5sum for a message object of type '<Neck-response>"
  "a4c3e5c0a24d8ee61cbbe52751e76b37")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Neck-response)))
  "Returns md5sum for a message object of type 'Neck-response"
  "a4c3e5c0a24d8ee61cbbe52751e76b37")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Neck-response>)))
  "Returns full string definition for message of type '<Neck-response>"
  (cl:format cl:nil "string result~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Neck-response)))
  "Returns full string definition for message of type 'Neck-response"
  (cl:format cl:nil "string result~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Neck-response>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'result))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Neck-response>))
  "Converts a ROS message object to a list"
  (cl:list 'Neck-response
    (cl:cons ':result (result msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'Neck)))
  'Neck-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'Neck)))
  'Neck-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Neck)))
  "Returns string type for a service object of type '<Neck>"
  "bobac3_msgs/Neck")