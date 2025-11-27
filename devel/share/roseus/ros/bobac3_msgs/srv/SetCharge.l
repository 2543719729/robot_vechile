;; Auto-generated. Do not edit!


(when (boundp 'bobac3_msgs::SetCharge)
  (if (not (find-package "BOBAC3_MSGS"))
    (make-package "BOBAC3_MSGS"))
  (shadow 'SetCharge (find-package "BOBAC3_MSGS")))
(unless (find-package "BOBAC3_MSGS::SETCHARGE")
  (make-package "BOBAC3_MSGS::SETCHARGE"))
(unless (find-package "BOBAC3_MSGS::SETCHARGEREQUEST")
  (make-package "BOBAC3_MSGS::SETCHARGEREQUEST"))
(unless (find-package "BOBAC3_MSGS::SETCHARGERESPONSE")
  (make-package "BOBAC3_MSGS::SETCHARGERESPONSE"))

(in-package "ROS")





(defclass bobac3_msgs::SetChargeRequest
  :super ros::object
  :slots (_charge ))

(defmethod bobac3_msgs::SetChargeRequest
  (:init
   (&key
    ((:charge __charge) 0)
    )
   (send-super :init)
   (setq _charge (round __charge))
   self)
  (:charge
   (&optional __charge)
   (if __charge (setq _charge __charge)) _charge)
  (:serialization-length
   ()
   (+
    ;; int8 _charge
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int8 _charge
       (write-byte _charge s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int8 _charge
     (setq _charge (sys::peek buf ptr- :char)) (incf ptr- 1)
     (if (> _charge 127) (setq _charge (- _charge 256)))
   ;;
   self)
  )

(defclass bobac3_msgs::SetChargeResponse
  :super ros::object
  :slots (_message _success ))

(defmethod bobac3_msgs::SetChargeResponse
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

(defclass bobac3_msgs::SetCharge
  :super ros::object
  :slots ())

(setf (get bobac3_msgs::SetCharge :md5sum-) "3f6258d38a544c9f83b2feeb068d4950")
(setf (get bobac3_msgs::SetCharge :datatype-) "bobac3_msgs/SetCharge")
(setf (get bobac3_msgs::SetCharge :request) bobac3_msgs::SetChargeRequest)
(setf (get bobac3_msgs::SetCharge :response) bobac3_msgs::SetChargeResponse)

(defmethod bobac3_msgs::SetChargeRequest
  (:response () (instance bobac3_msgs::SetChargeResponse :init)))

(setf (get bobac3_msgs::SetChargeRequest :md5sum-) "3f6258d38a544c9f83b2feeb068d4950")
(setf (get bobac3_msgs::SetChargeRequest :datatype-) "bobac3_msgs/SetChargeRequest")
(setf (get bobac3_msgs::SetChargeRequest :definition-)
      "int8 charge 
---
string message
bool success 

")

(setf (get bobac3_msgs::SetChargeResponse :md5sum-) "3f6258d38a544c9f83b2feeb068d4950")
(setf (get bobac3_msgs::SetChargeResponse :datatype-) "bobac3_msgs/SetChargeResponse")
(setf (get bobac3_msgs::SetChargeResponse :definition-)
      "int8 charge 
---
string message
bool success 

")



(provide :bobac3_msgs/SetCharge "3f6258d38a544c9f83b2feeb068d4950")


