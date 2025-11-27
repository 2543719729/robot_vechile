;; Auto-generated. Do not edit!


(when (boundp 'bobac3_msgs::Neck)
  (if (not (find-package "BOBAC3_MSGS"))
    (make-package "BOBAC3_MSGS"))
  (shadow 'Neck (find-package "BOBAC3_MSGS")))
(unless (find-package "BOBAC3_MSGS::NECK")
  (make-package "BOBAC3_MSGS::NECK"))
(unless (find-package "BOBAC3_MSGS::NECKREQUEST")
  (make-package "BOBAC3_MSGS::NECKREQUEST"))
(unless (find-package "BOBAC3_MSGS::NECKRESPONSE")
  (make-package "BOBAC3_MSGS::NECKRESPONSE"))

(in-package "ROS")





(defclass bobac3_msgs::NeckRequest
  :super ros::object
  :slots (_angle ))

(defmethod bobac3_msgs::NeckRequest
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

(defclass bobac3_msgs::NeckResponse
  :super ros::object
  :slots (_result ))

(defmethod bobac3_msgs::NeckResponse
  (:init
   (&key
    ((:result __result) "")
    )
   (send-super :init)
   (setq _result (string __result))
   self)
  (:result
   (&optional __result)
   (if __result (setq _result __result)) _result)
  (:serialization-length
   ()
   (+
    ;; string _result
    4 (length _result)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _result
       (write-long (length _result) s) (princ _result s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _result
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _result (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(defclass bobac3_msgs::Neck
  :super ros::object
  :slots ())

(setf (get bobac3_msgs::Neck :md5sum-) "a4c3e5c0a24d8ee61cbbe52751e76b37")
(setf (get bobac3_msgs::Neck :datatype-) "bobac3_msgs/Neck")
(setf (get bobac3_msgs::Neck :request) bobac3_msgs::NeckRequest)
(setf (get bobac3_msgs::Neck :response) bobac3_msgs::NeckResponse)

(defmethod bobac3_msgs::NeckRequest
  (:response () (instance bobac3_msgs::NeckResponse :init)))

(setf (get bobac3_msgs::NeckRequest :md5sum-) "a4c3e5c0a24d8ee61cbbe52751e76b37")
(setf (get bobac3_msgs::NeckRequest :datatype-) "bobac3_msgs/NeckRequest")
(setf (get bobac3_msgs::NeckRequest :definition-)
      "int16 angle
---
string result

")

(setf (get bobac3_msgs::NeckResponse :md5sum-) "a4c3e5c0a24d8ee61cbbe52751e76b37")
(setf (get bobac3_msgs::NeckResponse :datatype-) "bobac3_msgs/NeckResponse")
(setf (get bobac3_msgs::NeckResponse :definition-)
      "int16 angle
---
string result

")



(provide :bobac3_msgs/Neck "a4c3e5c0a24d8ee61cbbe52751e76b37")


