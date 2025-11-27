; Auto-generated. Do not edit!


(cl:in-package bobac3_msgs-srv)


;//! \htmlinclude SetCharge-request.msg.html

(cl:defclass <SetCharge-request> (roslisp-msg-protocol:ros-message)
  ((charge
    :reader charge
    :initarg :charge
    :type cl:fixnum
    :initform 0))
)

(cl:defclass SetCharge-request (<SetCharge-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SetCharge-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SetCharge-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-srv:<SetCharge-request> is deprecated: use bobac3_msgs-srv:SetCharge-request instead.")))

(cl:ensure-generic-function 'charge-val :lambda-list '(m))
(cl:defmethod charge-val ((m <SetCharge-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-srv:charge-val is deprecated.  Use bobac3_msgs-srv:charge instead.")
  (charge m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SetCharge-request>) ostream)
  "Serializes a message object of type '<SetCharge-request>"
  (cl:let* ((signed (cl:slot-value msg 'charge)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 256) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    )
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SetCharge-request>) istream)
  "Deserializes a message object of type '<SetCharge-request>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'charge) (cl:if (cl:< unsigned 128) unsigned (cl:- unsigned 256))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SetCharge-request>)))
  "Returns string type for a service object of type '<SetCharge-request>"
  "bobac3_msgs/SetChargeRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SetCharge-request)))
  "Returns string type for a service object of type 'SetCharge-request"
  "bobac3_msgs/SetChargeRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SetCharge-request>)))
  "Returns md5sum for a message object of type '<SetCharge-request>"
  "3f6258d38a544c9f83b2feeb068d4950")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SetCharge-request)))
  "Returns md5sum for a message object of type 'SetCharge-request"
  "3f6258d38a544c9f83b2feeb068d4950")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SetCharge-request>)))
  "Returns full string definition for message of type '<SetCharge-request>"
  (cl:format cl:nil "int8 charge ~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SetCharge-request)))
  "Returns full string definition for message of type 'SetCharge-request"
  (cl:format cl:nil "int8 charge ~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SetCharge-request>))
  (cl:+ 0
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SetCharge-request>))
  "Converts a ROS message object to a list"
  (cl:list 'SetCharge-request
    (cl:cons ':charge (charge msg))
))
;//! \htmlinclude SetCharge-response.msg.html

(cl:defclass <SetCharge-response> (roslisp-msg-protocol:ros-message)
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

(cl:defclass SetCharge-response (<SetCharge-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SetCharge-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SetCharge-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-srv:<SetCharge-response> is deprecated: use bobac3_msgs-srv:SetCharge-response instead.")))

(cl:ensure-generic-function 'message-val :lambda-list '(m))
(cl:defmethod message-val ((m <SetCharge-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-srv:message-val is deprecated.  Use bobac3_msgs-srv:message instead.")
  (message m))

(cl:ensure-generic-function 'success-val :lambda-list '(m))
(cl:defmethod success-val ((m <SetCharge-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-srv:success-val is deprecated.  Use bobac3_msgs-srv:success instead.")
  (success m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SetCharge-response>) ostream)
  "Serializes a message object of type '<SetCharge-response>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'message))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'message))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'success) 1 0)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SetCharge-response>) istream)
  "Deserializes a message object of type '<SetCharge-response>"
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
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SetCharge-response>)))
  "Returns string type for a service object of type '<SetCharge-response>"
  "bobac3_msgs/SetChargeResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SetCharge-response)))
  "Returns string type for a service object of type 'SetCharge-response"
  "bobac3_msgs/SetChargeResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SetCharge-response>)))
  "Returns md5sum for a message object of type '<SetCharge-response>"
  "3f6258d38a544c9f83b2feeb068d4950")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SetCharge-response)))
  "Returns md5sum for a message object of type 'SetCharge-response"
  "3f6258d38a544c9f83b2feeb068d4950")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SetCharge-response>)))
  "Returns full string definition for message of type '<SetCharge-response>"
  (cl:format cl:nil "string message~%bool success ~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SetCharge-response)))
  "Returns full string definition for message of type 'SetCharge-response"
  (cl:format cl:nil "string message~%bool success ~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SetCharge-response>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'message))
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SetCharge-response>))
  "Converts a ROS message object to a list"
  (cl:list 'SetCharge-response
    (cl:cons ':message (message msg))
    (cl:cons ':success (success msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'SetCharge)))
  'SetCharge-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'SetCharge)))
  'SetCharge-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SetCharge)))
  "Returns string type for a service object of type '<SetCharge>"
  "bobac3_msgs/SetCharge")