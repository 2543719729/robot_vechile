;; Auto-generated. Do not edit!


(when (boundp 'bobac3_msgs::joint)
  (if (not (find-package "BOBAC3_MSGS"))
    (make-package "BOBAC3_MSGS"))
  (shadow 'joint (find-package "BOBAC3_MSGS")))
(unless (find-package "BOBAC3_MSGS::JOINT")
  (make-package "BOBAC3_MSGS::JOINT"))

(in-package "ROS")
;;//! \htmlinclude joint.msg.html
(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(defclass bobac3_msgs::joint
  :super ros::object
  :slots (_joint_name _joint_position _confidence ))

(defmethod bobac3_msgs::joint
  (:init
   (&key
    ((:joint_name __joint_name) "")
    ((:joint_position __joint_position) (instance geometry_msgs::Point :init))
    ((:confidence __confidence) 0.0)
    )
   (send-super :init)
   (setq _joint_name (string __joint_name))
   (setq _joint_position __joint_position)
   (setq _confidence (float __confidence))
   self)
  (:joint_name
   (&optional __joint_name)
   (if __joint_name (setq _joint_name __joint_name)) _joint_name)
  (:joint_position
   (&rest __joint_position)
   (if (keywordp (car __joint_position))
       (send* _joint_position __joint_position)
     (progn
       (if __joint_position (setq _joint_position (car __joint_position)))
       _joint_position)))
  (:confidence
   (&optional __confidence)
   (if __confidence (setq _confidence __confidence)) _confidence)
  (:serialization-length
   ()
   (+
    ;; string _joint_name
    4 (length _joint_name)
    ;; geometry_msgs/Point _joint_position
    (send _joint_position :serialization-length)
    ;; float32 _confidence
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _joint_name
       (write-long (length _joint_name) s) (princ _joint_name s)
     ;; geometry_msgs/Point _joint_position
       (send _joint_position :serialize s)
     ;; float32 _confidence
       (sys::poke _confidence (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _joint_name
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _joint_name (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; geometry_msgs/Point _joint_position
     (send _joint_position :deserialize buf ptr-) (incf ptr- (send _joint_position :serialization-length))
   ;; float32 _confidence
     (setq _confidence (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get bobac3_msgs::joint :md5sum-) "759c2dfdf04327dc9ad25824b6b8bf26")
(setf (get bobac3_msgs::joint :datatype-) "bobac3_msgs/joint")
(setf (get bobac3_msgs::joint :definition-)
      "string joint_name
geometry_msgs/Point joint_position
float32 confidence

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

")



(provide :bobac3_msgs/joint "759c2dfdf04327dc9ad25824b6b8bf26")


