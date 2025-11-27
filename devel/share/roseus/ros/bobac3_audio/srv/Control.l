;; Auto-generated. Do not edit!


(when (boundp 'bobac3_audio::Control)
  (if (not (find-package "BOBAC3_AUDIO"))
    (make-package "BOBAC3_AUDIO"))
  (shadow 'Control (find-package "BOBAC3_AUDIO")))
(unless (find-package "BOBAC3_AUDIO::CONTROL")
  (make-package "BOBAC3_AUDIO::CONTROL"))
(unless (find-package "BOBAC3_AUDIO::CONTROLREQUEST")
  (make-package "BOBAC3_AUDIO::CONTROLREQUEST"))
(unless (find-package "BOBAC3_AUDIO::CONTROLRESPONSE")
  (make-package "BOBAC3_AUDIO::CONTROLRESPONSE"))

(in-package "ROS")





(defclass bobac3_audio::ControlRequest
  :super ros::object
  :slots (_controlInfo _value ))

(defmethod bobac3_audio::ControlRequest
  (:init
   (&key
    ((:controlInfo __controlInfo) (let (r) (dotimes (i 0) (push "" r)) r))
    ((:value __value) 0.0)
    )
   (send-super :init)
   (setq _controlInfo __controlInfo)
   (setq _value (float __value))
   self)
  (:controlInfo
   (&optional __controlInfo)
   (if __controlInfo (setq _controlInfo __controlInfo)) _controlInfo)
  (:value
   (&optional __value)
   (if __value (setq _value __value)) _value)
  (:serialization-length
   ()
   (+
    ;; string[] _controlInfo
    (apply #'+ (mapcar #'(lambda (x) (+ 4 (length x))) _controlInfo)) 4
    ;; float32 _value
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string[] _controlInfo
     (write-long (length _controlInfo) s)
     (dolist (elem _controlInfo)
       (write-long (length elem) s) (princ elem s)
       )
     ;; float32 _value
       (sys::poke _value (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string[] _controlInfo
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _controlInfo (make-list n))
     (dotimes (i n)
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setf (elt _controlInfo i) (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
     ))
   ;; float32 _value
     (setq _value (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(defclass bobac3_audio::ControlResponse
  :super ros::object
  :slots (_result ))

(defmethod bobac3_audio::ControlResponse
  (:init
   (&key
    ((:result __result) nil)
    )
   (send-super :init)
   (setq _result __result)
   self)
  (:result
   (&optional (__result :null))
   (if (not (eq __result :null)) (setq _result __result)) _result)
  (:serialization-length
   ()
   (+
    ;; bool _result
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; bool _result
       (if _result (write-byte -1 s) (write-byte 0 s))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; bool _result
     (setq _result (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;;
   self)
  )

(defclass bobac3_audio::Control
  :super ros::object
  :slots ())

(setf (get bobac3_audio::Control :md5sum-) "d9d592028a39d44769bfd310193595a8")
(setf (get bobac3_audio::Control :datatype-) "bobac3_audio/Control")
(setf (get bobac3_audio::Control :request) bobac3_audio::ControlRequest)
(setf (get bobac3_audio::Control :response) bobac3_audio::ControlResponse)

(defmethod bobac3_audio::ControlRequest
  (:response () (instance bobac3_audio::ControlResponse :init)))

(setf (get bobac3_audio::ControlRequest :md5sum-) "d9d592028a39d44769bfd310193595a8")
(setf (get bobac3_audio::ControlRequest :datatype-) "bobac3_audio/ControlRequest")
(setf (get bobac3_audio::ControlRequest :definition-)
      "string[] controlInfo
float32 value
---
bool result

")

(setf (get bobac3_audio::ControlResponse :md5sum-) "d9d592028a39d44769bfd310193595a8")
(setf (get bobac3_audio::ControlResponse :datatype-) "bobac3_audio/ControlResponse")
(setf (get bobac3_audio::ControlResponse :definition-)
      "string[] controlInfo
float32 value
---
bool result

")



(provide :bobac3_audio/Control "d9d592028a39d44769bfd310193595a8")


