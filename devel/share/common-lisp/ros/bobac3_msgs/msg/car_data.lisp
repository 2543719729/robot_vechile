; Auto-generated. Do not edit!


(cl:in-package bobac3_msgs-msg)


;//! \htmlinclude car_data.msg.html

(cl:defclass <car_data> (roslisp-msg-protocol:ros-message)
  ((speed
    :reader speed
    :initarg :speed
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0))
   (crash
    :reader crash
    :initarg :crash
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 0 :element-type 'cl:fixnum :initial-element 0))
   (infrared
    :reader infrared
    :initarg :infrared
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 0 :element-type 'cl:fixnum :initial-element 0))
   (ultrasonic
    :reader ultrasonic
    :initarg :ultrasonic
    :type (cl:vector cl:fixnum)
   :initform (cl:make-array 0 :element-type 'cl:fixnum :initial-element 0))
   (smoke
    :reader smoke
    :initarg :smoke
    :type cl:fixnum
    :initform 0)
   (power_voltage
    :reader power_voltage
    :initarg :power_voltage
    :type cl:fixnum
    :initform 0)
   (mpu
    :reader mpu
    :initarg :mpu
    :type (cl:vector cl:float)
   :initform (cl:make-array 0 :element-type 'cl:float :initial-element 0.0))
   (tempareture
    :reader tempareture
    :initarg :tempareture
    :type cl:float
    :initform 0.0)
   (humidity
    :reader humidity
    :initarg :humidity
    :type cl:float
    :initform 0.0))
)

(cl:defclass car_data (<car_data>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <car_data>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'car_data)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name bobac3_msgs-msg:<car_data> is deprecated: use bobac3_msgs-msg:car_data instead.")))

(cl:ensure-generic-function 'speed-val :lambda-list '(m))
(cl:defmethod speed-val ((m <car_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:speed-val is deprecated.  Use bobac3_msgs-msg:speed instead.")
  (speed m))

(cl:ensure-generic-function 'crash-val :lambda-list '(m))
(cl:defmethod crash-val ((m <car_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:crash-val is deprecated.  Use bobac3_msgs-msg:crash instead.")
  (crash m))

(cl:ensure-generic-function 'infrared-val :lambda-list '(m))
(cl:defmethod infrared-val ((m <car_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:infrared-val is deprecated.  Use bobac3_msgs-msg:infrared instead.")
  (infrared m))

(cl:ensure-generic-function 'ultrasonic-val :lambda-list '(m))
(cl:defmethod ultrasonic-val ((m <car_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:ultrasonic-val is deprecated.  Use bobac3_msgs-msg:ultrasonic instead.")
  (ultrasonic m))

(cl:ensure-generic-function 'smoke-val :lambda-list '(m))
(cl:defmethod smoke-val ((m <car_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:smoke-val is deprecated.  Use bobac3_msgs-msg:smoke instead.")
  (smoke m))

(cl:ensure-generic-function 'power_voltage-val :lambda-list '(m))
(cl:defmethod power_voltage-val ((m <car_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:power_voltage-val is deprecated.  Use bobac3_msgs-msg:power_voltage instead.")
  (power_voltage m))

(cl:ensure-generic-function 'mpu-val :lambda-list '(m))
(cl:defmethod mpu-val ((m <car_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:mpu-val is deprecated.  Use bobac3_msgs-msg:mpu instead.")
  (mpu m))

(cl:ensure-generic-function 'tempareture-val :lambda-list '(m))
(cl:defmethod tempareture-val ((m <car_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:tempareture-val is deprecated.  Use bobac3_msgs-msg:tempareture instead.")
  (tempareture m))

(cl:ensure-generic-function 'humidity-val :lambda-list '(m))
(cl:defmethod humidity-val ((m <car_data>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader bobac3_msgs-msg:humidity-val is deprecated.  Use bobac3_msgs-msg:humidity instead.")
  (humidity m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <car_data>) ostream)
  "Serializes a message object of type '<car_data>"
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
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'crash))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) ele) ostream))
   (cl:slot-value msg 'crash))
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'infrared))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) ele) ostream))
   (cl:slot-value msg 'infrared))
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'ultrasonic))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:write-byte (cl:ldb (cl:byte 8 0) ele) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) ele) ostream))
   (cl:slot-value msg 'ultrasonic))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'smoke)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'smoke)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'power_voltage)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'power_voltage)) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'mpu))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (cl:let ((bits (roslisp-utils:encode-single-float-bits ele)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)))
   (cl:slot-value msg 'mpu))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'tempareture))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'humidity))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <car_data>) istream)
  "Deserializes a message object of type '<car_data>"
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
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'crash) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'crash)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:aref vals i)) (cl:read-byte istream)))))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'infrared) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'infrared)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:aref vals i)) (cl:read-byte istream)))))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'ultrasonic) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'ultrasonic)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:aref vals i)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:aref vals i)) (cl:read-byte istream)))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'smoke)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'smoke)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'power_voltage)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'power_voltage)) (cl:read-byte istream))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'mpu) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'mpu)))
    (cl:dotimes (i __ros_arr_len)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:aref vals i) (roslisp-utils:decode-single-float-bits bits))))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'tempareture) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'humidity) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<car_data>)))
  "Returns string type for a message object of type '<car_data>"
  "bobac3_msgs/car_data")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'car_data)))
  "Returns string type for a message object of type 'car_data"
  "bobac3_msgs/car_data")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<car_data>)))
  "Returns md5sum for a message object of type '<car_data>"
  "2cce16e01821bbf3f6a71093439b392f")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'car_data)))
  "Returns md5sum for a message object of type 'car_data"
  "2cce16e01821bbf3f6a71093439b392f")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<car_data>)))
  "Returns full string definition for message of type '<car_data>"
  (cl:format cl:nil "float64[] speed~%uint16[] crash~%uint16[] infrared~%uint16[] ultrasonic~%uint16 smoke~%uint16 power_voltage~%float32[] mpu~%float32 tempareture~%float32 humidity~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'car_data)))
  "Returns full string definition for message of type 'car_data"
  (cl:format cl:nil "float64[] speed~%uint16[] crash~%uint16[] infrared~%uint16[] ultrasonic~%uint16 smoke~%uint16 power_voltage~%float32[] mpu~%float32 tempareture~%float32 humidity~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <car_data>))
  (cl:+ 0
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'speed) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 8)))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'crash) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 2)))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'infrared) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 2)))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'ultrasonic) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 2)))
     2
     2
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'mpu) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ 4)))
     4
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <car_data>))
  "Converts a ROS message object to a list"
  (cl:list 'car_data
    (cl:cons ':speed (speed msg))
    (cl:cons ':crash (crash msg))
    (cl:cons ':infrared (infrared msg))
    (cl:cons ':ultrasonic (ultrasonic msg))
    (cl:cons ':smoke (smoke msg))
    (cl:cons ':power_voltage (power_voltage msg))
    (cl:cons ':mpu (mpu msg))
    (cl:cons ':tempareture (tempareture msg))
    (cl:cons ':humidity (humidity msg))
))
