; Auto-generated. Do not edit!


(cl:in-package bobac3_msgs-srv)


;//! \htmlinclude SetRelativeMove-request.msg.html

(cl:defclass <SetRelativeMove-request> (roslisp-msg-protocol:ros-message)
  ((relative_move
    :reader relative_move
    :initarg :relative_move
    :type cl:float
    :initform 0.0)
   (mode
    :reader mode
    :initarg :mode
    :type cl:fixnum
    :initform 0))
)

(cl:defclass SetRelativeMove-request (<SetRelativeMove-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SetRelativeMove-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SetRelativeMove-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-srv:<SetRelativeMove-request> is deprecated: use bobac3_msgs-srv:SetRelativeMove-request instead.")))

(cl:ensure-generic-function 'relative_move-val :lambda-list '(m))
(cl:defmethod relative_move-val ((m <SetRelativeMove-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-srv:relative_move-val is deprecated.  Use bobac3_msgs-srv:relative_move instead.")
  (relative_move m))

(cl:ensure-generic-function 'mode-val :lambda-list '(m))
(cl:defmethod mode-val ((m <SetRelativeMove-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-srv:mode-val is deprecated.  Use bobac3_msgs-srv:mode instead.")
  (mode m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SetRelativeMove-request>) ostream)
  "Serializes a message object of type '<SetRelativeMove-request>"
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'relative_move))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'mode)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SetRelativeMove-request>) istream)
  "Deserializes a message object of type '<SetRelativeMove-request>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'relative_move) (roslisp-utils:decode-single-float-bits bits)))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'mode)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SetRelativeMove-request>)))
  "Returns string type for a service object of type '<SetRelativeMove-request>"
  "bobac3_msgs/SetRelativeMoveRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SetRelativeMove-request)))
  "Returns string type for a service object of type 'SetRelativeMove-request"
  "bobac3_msgs/SetRelativeMoveRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SetRelativeMove-request>)))
  "Returns md5sum for a message object of type '<SetRelativeMove-request>"
  "368b2dd44c53d8761c3201db559483c3")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SetRelativeMove-request)))
  "Returns md5sum for a message object of type 'SetRelativeMove-request"
  "368b2dd44c53d8761c3201db559483c3")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SetRelativeMove-request>)))
  "Returns full string definition for message of type '<SetRelativeMove-request>"
  (cl:format cl:nil "float32 relative_move~%uint8 mode~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SetRelativeMove-request)))
  "Returns full string definition for message of type 'SetRelativeMove-request"
  (cl:format cl:nil "float32 relative_move~%uint8 mode~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SetRelativeMove-request>))
  (cl:+ 0
     4
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SetRelativeMove-request>))
  "Converts a ROS message object to a list"
  (cl:list 'SetRelativeMove-request
    (cl:cons ':relative_move (relative_move msg))
    (cl:cons ':mode (mode msg))
))
;//! \htmlinclude SetRelativeMove-response.msg.html

(cl:defclass <SetRelativeMove-response> (roslisp-msg-protocol:ros-message)
  ((success
    :reader success
    :initarg :success
    :type cl:boolean
    :initform cl:nil)
   (message
    :reader message
    :initarg :message
    :type cl:string
    :initform ""))
)

(cl:defclass SetRelativeMove-response (<SetRelativeMove-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SetRelativeMove-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SetRelativeMove-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-srv:<SetRelativeMove-response> is deprecated: use bobac3_msgs-srv:SetRelativeMove-response instead.")))

(cl:ensure-generic-function 'success-val :lambda-list '(m))
(cl:defmethod success-val ((m <SetRelativeMove-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-srv:success-val is deprecated.  Use bobac3_msgs-srv:success instead.")
  (success m))

(cl:ensure-generic-function 'message-val :lambda-list '(m))
(cl:defmethod message-val ((m <SetRelativeMove-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-srv:message-val is deprecated.  Use bobac3_msgs-srv:message instead.")
  (message m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SetRelativeMove-response>) ostream)
  "Serializes a message object of type '<SetRelativeMove-response>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'success) 1 0)) ostream)
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'message))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'message))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SetRelativeMove-response>) istream)
  "Deserializes a message object of type '<SetRelativeMove-response>"
    (cl:setf (cl:slot-value msg 'success) (cl:not (cl:zerop (cl:read-byte istream))))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'message) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'message) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SetRelativeMove-response>)))
  "Returns string type for a service object of type '<SetRelativeMove-response>"
  "bobac3_msgs/SetRelativeMoveResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SetRelativeMove-response)))
  "Returns string type for a service object of type 'SetRelativeMove-response"
  "bobac3_msgs/SetRelativeMoveResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SetRelativeMove-response>)))
  "Returns md5sum for a message object of type '<SetRelativeMove-response>"
  "368b2dd44c53d8761c3201db559483c3")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SetRelativeMove-response)))
  "Returns md5sum for a message object of type 'SetRelativeMove-response"
  "368b2dd44c53d8761c3201db559483c3")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SetRelativeMove-response>)))
  "Returns full string definition for message of type '<SetRelativeMove-response>"
  (cl:format cl:nil "bool success~%string message~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SetRelativeMove-response)))
  "Returns full string definition for message of type 'SetRelativeMove-response"
  (cl:format cl:nil "bool success~%string message~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SetRelativeMove-response>))
  (cl:+ 0
     1
     4 (cl:length (cl:slot-value msg 'message))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SetRelativeMove-response>))
  "Converts a ROS message object to a list"
  (cl:list 'SetRelativeMove-response
    (cl:cons ':success (success msg))
    (cl:cons ':message (message msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'SetRelativeMove)))
  'SetRelativeMove-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'SetRelativeMove)))
  'SetRelativeMove-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SetRelativeMove)))
  "Returns string type for a service object of type '<SetRelativeMove>"
  "bobac3_msgs/SetRelativeMove")