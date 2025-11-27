;; Auto-generated. Do not edit!


(when (boundp 'third_pkg::myTestSrv)
  (if (not (find-package "THIRD_PKG"))
    (make-package "THIRD_PKG"))
  (shadow 'myTestSrv (find-package "THIRD_PKG")))
(unless (find-package "THIRD_PKG::MYTESTSRV")
  (make-package "THIRD_PKG::MYTESTSRV"))
(unless (find-package "THIRD_PKG::MYTESTSRVREQUEST")
  (make-package "THIRD_PKG::MYTESTSRVREQUEST"))
(unless (find-package "THIRD_PKG::MYTESTSRVRESPONSE")
  (make-package "THIRD_PKG::MYTESTSRVRESPONSE"))

(in-package "ROS")





(defclass third_pkg::myTestSrvRequest
  :super ros::object
  :slots (_index ))

(defmethod third_pkg::myTestSrvRequest
  (:init
   (&key
    ((:index __index) 0)
    )
   (send-super :init)
   (setq _index (round __index))
   self)
  (:index
   (&optional __index)
   (if __index (setq _index __index)) _index)
  (:serialization-length
   ()
   (+
    ;; int32 _index
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int32 _index
       (write-long _index s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int32 _index
     (setq _index (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;;
   self)
  )

(defclass third_pkg::myTestSrvResponse
  :super ros::object
  :slots (_result ))

(defmethod third_pkg::myTestSrvResponse
  (:init
   (&key
    ((:result __result) 0)
    )
   (send-super :init)
   (setq _result (round __result))
   self)
  (:result
   (&optional __result)
   (if __result (setq _result __result)) _result)
  (:serialization-length
   ()
   (+
    ;; int32 _result
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int32 _result
       (write-long _result s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int32 _result
     (setq _result (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;;
   self)
  )

(defclass third_pkg::myTestSrv
  :super ros::object
  :slots ())

(setf (get third_pkg::myTestSrv :md5sum-) "7f7a0363c34235e95bbd3987c4d4684d")
(setf (get third_pkg::myTestSrv :datatype-) "third_pkg/myTestSrv")
(setf (get third_pkg::myTestSrv :request) third_pkg::myTestSrvRequest)
(setf (get third_pkg::myTestSrv :response) third_pkg::myTestSrvResponse)

(defmethod third_pkg::myTestSrvRequest
  (:response () (instance third_pkg::myTestSrvResponse :init)))

(setf (get third_pkg::myTestSrvRequest :md5sum-) "7f7a0363c34235e95bbd3987c4d4684d")
(setf (get third_pkg::myTestSrvRequest :datatype-) "third_pkg/myTestSrvRequest")
(setf (get third_pkg::myTestSrvRequest :definition-)
      "int32 index
---
int32 result

")

(setf (get third_pkg::myTestSrvResponse :md5sum-) "7f7a0363c34235e95bbd3987c4d4684d")
(setf (get third_pkg::myTestSrvResponse :datatype-) "third_pkg/myTestSrvResponse")
(setf (get third_pkg::myTestSrvResponse :definition-)
      "int32 index
---
int32 result

")



(provide :third_pkg/myTestSrv "7f7a0363c34235e95bbd3987c4d4684d")


