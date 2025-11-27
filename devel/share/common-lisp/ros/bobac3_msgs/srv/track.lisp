; Auto-generated. Do not edit!


(cl:in-package bobac3_msgs-srv)


;//! \htmlinclude track-request.msg.html

(cl:defclass <track-request> (roslisp-msg-protocol:ros-message)
  ((track
    :reader track
    :initarg :track
    :type cl:fixnum
    :initform 0))
)

(cl:defclass track-request (<track-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <track-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'track-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-srv:<track-request> is deprecated: use bobac3_msgs-srv:track-request instead.")))

(cl:ensure-generic-function 'track-val :lambda-list '(m))
(cl:defmethod track-val ((m <track-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-srv:track-val is deprecated.  Use bobac3_msgs-srv:track instead.")
  (track m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <track-request>) ostream)
  "Serializes a message object of type '<track-request>"
  (cl:let* ((signed (cl:slot-value msg 'track)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <track-request>) istream)
  "Deserializes a message object of type '<track-request>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'track) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<track-request>)))
  "Returns string type for a service object of type '<track-request>"
  "bobac3_msgs/trackRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'track-request)))
  "Returns string type for a service object of type 'track-request"
  "bobac3_msgs/trackRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<track-request>)))
  "Returns md5sum for a message object of type '<track-request>"
  "b9a74275b260921b5af8eb282215e412")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'track-request)))
  "Returns md5sum for a message object of type 'track-request"
  "b9a74275b260921b5af8eb282215e412")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<track-request>)))
  "Returns full string definition for message of type '<track-request>"
  (cl:format cl:nil "int8 track~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'track-request)))
  "Returns full string definition for message of type 'track-request"
  (cl:format cl:nil "int8 track~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <track-request>))
  (cl:+ 0
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <track-request>))
  "Converts a ROS message object to a list"
  (cl:list 'track-request
    (cl:cons ':track (track msg))
))
;//! \htmlinclude track-response.msg.html

(cl:defclass <track-response> (roslisp-msg-protocol:ros-message)
  ((message
    :reader message
    :initarg :message
    :type cl:string
    :initform "")
   (success
    :reader success
    :initarg :success
    :type cl:boolean
    :initform cl:nil))
)

(cl:defclass track-response (<track-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <track-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'track-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-srv:<track-response> is deprecated: use bobac3_msgs-srv:track-response instead.")))

(cl:ensure-generic-function 'message-val :lambda-list '(m))
(cl:defmethod message-val ((m <track-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-srv:message-val is deprecated.  Use bobac3_msgs-srv:message instead.")
  (message m))

(cl:ensure-generic-function 'success-val :lambda-list '(m))
(cl:defmethod success-val ((m <track-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-srv:success-val is deprecated.  Use bobac3_msgs-srv:success instead.")
  (success m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <track-response>) ostream)
  "Serializes a message object of type '<track-response>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'message))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'message))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'success) 1 0)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <track-response>) istream)
  "Deserializes a message object of type '<track-response>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'message) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'message) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:setf (cl:slot-value msg 'success) (cl:not (cl:zerop (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<track-response>)))
  "Returns string type for a service object of type '<track-response>"
  "bobac3_msgs/trackResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'track-response)))
  "Returns string type for a service object of type 'track-response"
  "bobac3_msgs/trackResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<track-response>)))
  "Returns md5sum for a message object of type '<track-response>"
  "b9a74275b260921b5af8eb282215e412")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'track-response)))
  "Returns md5sum for a message object of type 'track-response"
  "b9a74275b260921b5af8eb282215e412")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<track-response>)))
  "Returns full string definition for message of type '<track-response>"
  (cl:format cl:nil "string message~%bool success~%~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'track-response)))
  "Returns full string definition for message of type 'track-response"
  (cl:format cl:nil "string message~%bool success~%~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <track-response>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'message))
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <track-response>))
  "Converts a ROS message object to a list"
  (cl:list 'track-response
    (cl:cons ':message (message msg))
    (cl:cons ':success (success msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'track)))
  'track-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'track)))
  'track-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'track)))
  "Returns string type for a service object of type '<track>"
  "bobac3_msgs/track")