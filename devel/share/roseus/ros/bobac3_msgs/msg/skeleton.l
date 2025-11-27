;; Auto-generated. Do not edit!


(when (boundp 'bobac3_msgs::skeleton)
  (if (not (find-package "BOBAC3_MSGS"))
    (make-package "BOBAC3_MSGS"))
  (shadow 'skeleton (find-package "BOBAC3_MSGS")))
(unless (find-package "BOBAC3_MSGS::SKELETON")
  (make-package "BOBAC3_MSGS::SKELETON"))

(in-package "ROS")
;;//! \htmlinclude skeleton.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass bobac3_msgs::skeleton
  :super ros::object
  :slots (_header _joints _success _sleep_flag ))

(defmethod bobac3_msgs::skeleton
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:joints __joints) ())
    ((:success __success) nil)
    ((:sleep_flag __sleep_flag) nil)
    )
   (send-super :init)
   (setq _header __header)
   (setq _joints __joints)
   (setq _success __success)
   (setq _sleep_flag __sleep_flag)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:joints
   (&rest __joints)
   (if (keywordp (car __joints))
       (send* _joints __joints)
     (progn
       (if __joints (setq _joints (car __joints)))
       _joints)))
  (:success
   (&optional (__success :null))
   (if (not (eq __success :null)) (setq _success __success)) _success)
  (:sleep_flag
   (&optional (__sleep_flag :null))
   (if (not (eq __sleep_flag :null)) (setq _sleep_flag __sleep_flag)) _sleep_flag)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; bobac3_msgs/joint[] _joints
    (apply #'+ (send-all _joints :serialization-length)) 4
    ;; bool _success
    1
    ;; bool _sleep_flag
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; bobac3_msgs/joint[] _joints
     (write-long (length _joints) s)
     (dolist (elem _joints)
       (send elem :serialize s)
       )
     ;; bool _success
       (if _success (write-byte -1 s) (write-byte 0 s))
     ;; bool _sleep_flag
       (if _sleep_flag (write-byte -1 s) (write-byte 0 s))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; bobac3_msgs/joint[] _joints
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _joints (let (r) (dotimes (i n) (push (instance bobac3_msgs::joint :init) r)) r))
     (dolist (elem- _joints)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;; bool _success
     (setq _success (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;; bool _sleep_flag
     (setq _sleep_flag (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;;
   self)
  )

(setf (get bobac3_msgs::skeleton :md5sum-) "ad0f444058310ab55aac22b0856240d6")
(setf (get bobac3_msgs::skeleton :datatype-) "bobac3_msgs/skeleton")
(setf (get bobac3_msgs::skeleton :definition-)
      "std_msgs/Header 	header
bobac3_msgs/joint[] 	joints
bool success
bool sleep_flag

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

================================================================================
MSG: bobac3_msgs/joint
string joint_name
geometry_msgs/Point joint_position
float32 confidence

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

")



(provide :bobac3_msgs/skeleton "ad0f444058310ab55aac22b0856240d6")


