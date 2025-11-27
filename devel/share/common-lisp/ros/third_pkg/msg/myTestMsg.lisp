; Auto-generated. Do not edit!


(cl:in-package third_pkg-msg)


;//! \htmlinclude myTestMsg.msg.html

(cl:defclass <myTestMsg> (roslisp-msg-protocol:ros-message)
  ((name
    :reader name
    :initarg :name
    :type cl:string
    :initform "")
   (age
    :reader age
    :initarg :age
    :type cl:fixnum
    :initform 0)
   (handsome
    :reader handsome
    :initarg :handsome
    :type cl:boolean
    :initform cl:nil)
   (salary
    :reader salary
    :initarg :salary
    :type cl:float
    :initform 0.0))
)

(cl:defclass myTestMsg (<myTestMsg>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <myTestMsg>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'myTestMsg)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name third_pkg-msg:<myTestMsg> is deprecated: use third_pkg-msg:myTestMsg instead.")))

(cl:ensure-generic-function 'name-val :lambda-list '(m))
(cl:defmethod name-val ((m <myTestMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader third_pkg-msg:name-val is deprecated.  Use third_pkg-msg:name instead.")
  (name m))

(cl:ensure-generic-function 'age-val :lambda-list '(m))
(cl:defmethod age-val ((m <myTestMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader third_pkg-msg:age-val is deprecated.  Use third_pkg-msg:age instead.")
  (age m))

(cl:ensure-generic-function 'handsome-val :lambda-list '(m))
(cl:defmethod handsome-val ((m <myTestMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader third_pkg-msg:handsome-val is deprecated.  Use third_pkg-msg:handsome instead.")
  (handsome m))

(cl:ensure-generic-function 'salary-val :lambda-list '(m))
(cl:defmethod salary-val ((m <myTestMsg>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader third_pkg-msg:salary-val is deprecated.  Use third_pkg-msg:salary instead.")
  (salary m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <myTestMsg>) ostream)
  "Serializes a message object of type '<myTestMsg>"
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'name))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'name))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'age)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'age)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'handsome) 1 0)) ostream)
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'salary))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <myTestMsg>) istream)
  "Deserializes a message object of type '<myTestMsg>"
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'name) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'name) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'age)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'age)) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'handsome) (cl:not (cl:zerop (cl:read-byte istream))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'salary) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<myTestMsg>)))
  "Returns string type for a message object of type '<myTestMsg>"
  "third_pkg/myTestMsg")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'myTestMsg)))
  "Returns string type for a message object of type 'myTestMsg"
  "third_pkg/myTestMsg")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<myTestMsg>)))
  "Returns md5sum for a message object of type '<myTestMsg>"
  "6ece56ce03fa8153af604f79dc40b971")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'myTestMsg)))
  "Returns md5sum for a message object of type 'myTestMsg"
  "6ece56ce03fa8153af604f79dc40b971")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<myTestMsg>)))
  "Returns full string definition for message of type '<myTestMsg>"
  (cl:format cl:nil "string name~%uint16 age~%bool handsome~%float32 salary~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'myTestMsg)))
  "Returns full string definition for message of type 'myTestMsg"
  (cl:format cl:nil "string name~%uint16 age~%bool handsome~%float32 salary~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <myTestMsg>))
  (cl:+ 0
     4 (cl:length (cl:slot-value msg 'name))
     2
     1
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <myTestMsg>))
  "Converts a ROS message object to a list"
  (cl:list 'myTestMsg
    (cl:cons ':name (name msg))
    (cl:cons ':age (age msg))
    (cl:cons ':handsome (handsome msg))
    (cl:cons ':salary (salary msg))
))
