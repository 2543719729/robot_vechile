;; Auto-generated. Do not edit!


(when (boundp 'bobac3_msgs::SetRelativeMove)
  (if (not (find-package "BOBAC3_MSGS"))
    (make-package "BOBAC3_MSGS"))
  (shadow 'SetRelativeMove (find-package "BOBAC3_MSGS")))
(unless (find-package "BOBAC3_MSGS::SETRELATIVEMOVE")
  (make-package "BOBAC3_MSGS::SETRELATIVEMOVE"))
(unless (find-package "BOBAC3_MSGS::SETRELATIVEMOVEREQUEST")
  (make-package "BOBAC3_MSGS::SETRELATIVEMOVEREQUEST"))
(unless (find-package "BOBAC3_MSGS::SETRELATIVEMOVERESPONSE")
  (make-package "BOBAC3_MSGS::SETRELATIVEMOVERESPONSE"))

(in-package "ROS")





(defclass bobac3_msgs::SetRelativeMoveRequest
  :super ros::object
  :slots (_relative_move _mode ))

(defmethod bobac3_msgs::SetRelativeMoveRequest
  (:init
   (&key
    ((:relative_move __relative_move) 0.0)
    ((:mode __mode) 0)
    )
   (send-super :init)
   (setq _relative_move (float __relative_move))
   (setq _mode (round __mode))
   self)
  (:relative_move
   (&optional __relative_move)
   (if __relative_move (setq _relative_move __relative_move)) _relative_move)
  (:mode
   (&optional __mode)
   (if __mode (setq _mode __mode)) _mode)
  (:serialization-length
   ()
   (+
    ;; float32 _relative_move
    4
    ;; uint8 _mode
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32 _relative_move
       (sys::poke _relative_move (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; uint8 _mode
       (write-byte _mode s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32 _relative_move
     (setq _relative_move (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; uint8 _mode
     (setq _mode (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;;
   self)
  )

(defclass bobac3_msgs::SetRelativeMoveResponse
  :super ros::object
  :slots (_success _message ))

(defmethod bobac3_msgs::SetRelativeMoveResponse
  (:init
   (&key
    ((:success __success) nil)
    ((:message __message) "")
    )
   (send-super :init)
   (setq _success __success)
   (setq _message (string __message))
   self)
  (:success
   (&optional (__success :null))
   (if (not (eq __success :null)) (setq _success __success)) _success)
  (:message
   (&optional __message)
   (if __message (setq _message __message)) _message)
  (:serialization-length
   ()
   (+
    ;; bool _success
    1
    ;; string _message
    4 (length _message)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; bool _success
       (if _success (write-byte -1 s) (write-byte 0 s))
     ;; string _message
       (write-long (length _message) s) (princ _message s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; bool _success
     (setq _success (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;; string _message
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _message (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(defclass bobac3_msgs::SetRelativeMove
  :super ros::object
  :slots ())

(setf (get bobac3_msgs::SetRelativeMove :md5sum-) "368b2dd44c53d8761c3201db559483c3")
(setf (get bobac3_msgs::SetRelativeMove :datatype-) "bobac3_msgs/SetRelativeMove")
(setf (get bobac3_msgs::SetRelativeMove :request) bobac3_msgs::SetRelativeMoveRequest)
(setf (get bobac3_msgs::SetRelativeMove :response) bobac3_msgs::SetRelativeMoveResponse)

(defmethod bobac3_msgs::SetRelativeMoveRequest
  (:response () (instance bobac3_msgs::SetRelativeMoveResponse :init)))

(setf (get bobac3_msgs::SetRelativeMoveRequest :md5sum-) "368b2dd44c53d8761c3201db559483c3")
(setf (get bobac3_msgs::SetRelativeMoveRequest :datatype-) "bobac3_msgs/SetRelativeMoveRequest")
(setf (get bobac3_msgs::SetRelativeMoveRequest :definition-)
      "float32 relative_move
uint8 mode
---
bool success
string message

")

(setf (get bobac3_msgs::SetRelativeMoveResponse :md5sum-) "368b2dd44c53d8761c3201db559483c3")
(setf (get bobac3_msgs::SetRelativeMoveResponse :datatype-) "bobac3_msgs/SetRelativeMoveResponse")
(setf (get bobac3_msgs::SetRelativeMoveResponse :definition-)
      "float32 relative_move
uint8 mode
---
bool success
string message

")



(provide :bobac3_msgs/SetRelativeMove "368b2dd44c53d8761c3201db559483c3")


