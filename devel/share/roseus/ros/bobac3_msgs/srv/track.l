;; Auto-generated. Do not edit!


(when (boundp 'bobac3_msgs::track)
  (if (not (find-package "BOBAC3_MSGS"))
    (make-package "BOBAC3_MSGS"))
  (shadow 'track (find-package "BOBAC3_MSGS")))
(unless (find-package "BOBAC3_MSGS::TRACK")
  (make-package "BOBAC3_MSGS::TRACK"))
(unless (find-package "BOBAC3_MSGS::TRACKREQUEST")
  (make-package "BOBAC3_MSGS::TRACKREQUEST"))
(unless (find-package "BOBAC3_MSGS::TRACKRESPONSE")
  (make-package "BOBAC3_MSGS::TRACKRESPONSE"))

(in-package "ROS")





(defclass bobac3_msgs::trackRequest
  :super ros::object
  :slots (_track ))

(defmethod bobac3_msgs::trackRequest
  (:init
   (&key
    ((:track __track) 0)
    )
   (send-super :init)
   (setq _track (round __track))
   self)
  (:track
   (&optional __track)
   (if __track (setq _track __track)) _track)
  (:serialization-length
   ()
   (+
    ;; int8 _track
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int8 _track
       (write-byte _track s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int8 _track
     (setq _track (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _track 127) (setq _track (- _track 256)))
   ;;
   self)
  )

(defclass bobac3_msgs::trackResponse
  :super ros::object
  :slots (_message _success ))

(defmethod bobac3_msgs::trackResponse
  (:init
   (&key
    ((:message __message) "")
    ((:success __success) nil)
    )
   (send-super :init)
   (setq _message (string __message))
   (setq _success __success)
   self)
  (:message
   (&optional __message)
   (if __message (setq _message __message)) _message)
  (:success
   (&optional (__success :null))
   (if (not (eq __success :null)) (setq _success __success)) _success)
  (:serialization-length
   ()
   (+
    ;; string _message
    4 (length _message)
    ;; bool _success
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _message
       (write-long (length _message) s) (princ _message s)
     ;; bool _success
       (if _success (write-byte -1 s) (write-byte 0 s))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _message
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _message (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; bool _success
     (setq _success (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;;
   self)
  )

(defclass bobac3_msgs::track
  :super ros::object
  :slots ())

(setf (get bobac3_msgs::track :md5sum-) "b9a74275b260921b5af8eb282215e412")
(setf (get bobac3_msgs::track :datatype-) "bobac3_msgs/track")
(setf (get bobac3_msgs::track :request) bobac3_msgs::trackRequest)
(setf (get bobac3_msgs::track :response) bobac3_msgs::trackResponse)

(defmethod bobac3_msgs::trackRequest
  (:response () (instance bobac3_msgs::trackResponse :init)))

(setf (get bobac3_msgs::trackRequest :md5sum-) "b9a74275b260921b5af8eb282215e412")
(setf (get bobac3_msgs::trackRequest :datatype-) "bobac3_msgs/trackRequest")
(setf (get bobac3_msgs::trackRequest :definition-)
      "int8 track
---
string message
bool success


")

(setf (get bobac3_msgs::trackResponse :md5sum-) "b9a74275b260921b5af8eb282215e412")
(setf (get bobac3_msgs::trackResponse :datatype-) "bobac3_msgs/trackResponse")
(setf (get bobac3_msgs::trackResponse :definition-)
      "int8 track
---
string message
bool success


")



(provide :bobac3_msgs/track "b9a74275b260921b5af8eb282215e412")


