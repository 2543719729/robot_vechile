; Auto-generated. Do not edit!


(cl:in-package third_pkg-srv)


;//! \htmlinclude myTestSrv-request.msg.html

(cl:defclass <myTestSrv-request> (roslisp-msg-protocol:ros-message)
  ((index
    :reader index
    :initarg :index
    :type cl:integer
    :initform 0))
)

(cl:defclass myTestSrv-request (<myTestSrv-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <myTestSrv-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'myTestSrv-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name third_pkg-srv:<myTestSrv-request> is deprecated: use third_pkg-srv:myTestSrv-request instead.")))

(cl:ensure-generic-function 'index-val :lambda-list '(m))
(cl:defmethod index-val ((m <myTestSrv-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader third_pkg-srv:index-val is deprecated.  Use third_pkg-srv:index instead.")
  (index m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <myTestSrv-request>) ostream)
  "Serializes a message object of type '<myTestSrv-request>"
  (cl:let* ((signed (cl:slot-value msg 'index)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <myTestSrv-request>) istream)
  "Deserializes a message object of type '<myTestSrv-request>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'index) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<myTestSrv-request>)))
  "Returns string type for a service object of type '<myTestSrv-request>"
  "third_pkg/myTestSrvRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'myTestSrv-request)))
  "Returns string type for a service object of type 'myTestSrv-request"
  "third_pkg/myTestSrvRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<myTestSrv-request>)))
  "Returns md5sum for a message object of type '<myTestSrv-request>"
  "7f7a0363c34235e95bbd3987c4d4684d")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'myTestSrv-request)))
  "Returns md5sum for a message object of type 'myTestSrv-request"
  "7f7a0363c34235e95bbd3987c4d4684d")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<myTestSrv-request>)))
  "Returns full string definition for message of type '<myTestSrv-request>"
  (cl:format cl:nil "int32 index~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'myTestSrv-request)))
  "Returns full string definition for message of type 'myTestSrv-request"
  (cl:format cl:nil "int32 index~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <myTestSrv-request>))
  (cl:+ 0
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <myTestSrv-request>))
  "Converts a ROS message object to a list"
  (cl:list 'myTestSrv-request
    (cl:cons ':index (index msg))
))
;//! \htmlinclude myTestSrv-response.msg.html

(cl:defclass <myTestSrv-response> (roslisp-msg-protocol:ros-message)
  ((result
    :reader result
    :initarg :result
    :type cl:integer
    :initform 0))
)

(cl:defclass myTestSrv-response (<myTestSrv-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <myTestSrv-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'myTestSrv-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name third_pkg-srv:<myTestSrv-response> is deprecated: use third_pkg-srv:myTestSrv-response instead.")))

(cl:ensure-generic-function 'result-val :lambda-list '(m))
(cl:defmethod result-val ((m <myTestSrv-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader third_pkg-srv:result-val is deprecated.  Use third_pkg-srv:result instead.")
  (result m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <myTestSrv-response>) ostream)
  "Serializes a message object of type '<myTestSrv-response>"
  (cl:let* ((signed (cl:slot-value msg 'result)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <myTestSrv-response>) istream)
  "Deserializes a message object of type '<myTestSrv-response>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'result) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<myTestSrv-response>)))
  "Returns string type for a service object of type '<myTestSrv-response>"
  "third_pkg/myTestSrvResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'myTestSrv-response)))
  "Returns string type for a service object of type 'myTestSrv-response"
  "third_pkg/myTestSrvResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<myTestSrv-response>)))
  "Returns md5sum for a message object of type '<myTestSrv-response>"
  "7f7a0363c34235e95bbd3987c4d4684d")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'myTestSrv-response)))
  "Returns md5sum for a message object of type 'myTestSrv-response"
  "7f7a0363c34235e95bbd3987c4d4684d")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<myTestSrv-response>)))
  "Returns full string definition for message of type '<myTestSrv-response>"
  (cl:format cl:nil "int32 result~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'myTestSrv-response)))
  "Returns full string definition for message of type 'myTestSrv-response"
  (cl:format cl:nil "int32 result~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <myTestSrv-response>))
  (cl:+ 0
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <myTestSrv-response>))
  "Converts a ROS message object to a list"
  (cl:list 'myTestSrv-response
    (cl:cons ':result (result msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'myTestSrv)))
  'myTestSrv-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'myTestSrv)))
  'myTestSrv-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'myTestSrv)))
  "Returns string type for a service object of type '<myTestSrv>"
  "third_pkg/myTestSrv")