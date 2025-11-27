;; Auto-generated. Do not edit!


(when (boundp 'bobac3_msgs::neck_angle)
  (if (not (find-package "BOBAC3_MSGS"))
    (make-package "BOBAC3_MSGS"))
  (shadow 'neck_angle (find-package "BOBAC3_MSGS")))
(unless (find-package "BOBAC3_MSGS::NECK_ANGLE")
  (make-package "BOBAC3_MSGS::NECK_ANGLE"))

(in-package "ROS")
;;//! \htmlinclude neck_angle.msg.html


(defclass bobac3_msgs::neck_angle
  :super ros::object
  :slots (_angle ))

(defmethod bobac3_msgs::neck_angle
  (:init
   (&key
    ((:angle __angle) 0)
    )
   (send-super :init)
   (setq _angle (round __angle))
   self)
  (:angle
   (&optional __angle)
   (if __angle (setq _angle __angle)) _angle)
  (:serialization-length
   ()
   (+
    ;; int16 _angle
    2
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int16 _angle
       (write-word _angle s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int16 _angle
     (setq _angle (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;;
   self)
  )

(setf (get bobac3_msgs::neck_angle :md5sum-) "ecd1f62d4afad57b40d43ebefe588fc8")
(setf (get bobac3_msgs::neck_angle :datatype-) "bobac3_msgs/neck_angle")
(setf (get bobac3_msgs::neck_angle :definition-)
      "int16 angle
")



(provide :bobac3_msgs/neck_angle "ecd1f62d4afad57b40d43ebefe588fc8")


