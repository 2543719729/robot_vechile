;; Auto-generated. Do not edit!


(when (boundp 'third_pkg::myTestMsg)
  (if (not (find-package "THIRD_PKG"))
    (make-package "THIRD_PKG"))
  (shadow 'myTestMsg (find-package "THIRD_PKG")))
(unless (find-package "THIRD_PKG::MYTESTMSG")
  (make-package "THIRD_PKG::MYTESTMSG"))

(in-package "ROS")
;;//! \htmlinclude myTestMsg.msg.html


(defclass third_pkg::myTestMsg
  :super ros::object
  :slots (_name _age _handsome _salary ))

(defmethod third_pkg::myTestMsg
  (:init
   (&key
    ((:name __name) "")
    ((:age __age) 0)
    ((:handsome __handsome) nil)
    ((:salary __salary) 0.0)
    )
   (send-super :init)
   (setq _name (string __name))
   (setq _age (round __age))
   (setq _handsome __handsome)
   (setq _salary (float __salary))
   self)
  (:name
   (&optional __name)
   (if __name (setq _name __name)) _name)
  (:age
   (&optional __age)
   (if __age (setq _age __age)) _age)
  (:handsome
   (&optional (__handsome :null))
   (if (not (eq __handsome :null)) (setq _handsome __handsome)) _handsome)
  (:salary
   (&optional __salary)
   (if __salary (setq _salary __salary)) _salary)
  (:serialization-length
   ()
   (+
    ;; string _name
    4 (length _name)
    ;; uint16 _age
    2
    ;; bool _handsome
    1
    ;; float32 _salary
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _name
       (write-long (length _name) s) (princ _name s)
     ;; uint16 _age
       (write-word _age s)
     ;; bool _handsome
       (if _handsome (write-byte -1 s) (write-byte 0 s))
     ;; float32 _salary
       (sys::poke _salary (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _name
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _name (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; uint16 _age
     (setq _age (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; bool _handsome
     (setq _handsome (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;; float32 _salary
     (setq _salary (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get third_pkg::myTestMsg :md5sum-) "6ece56ce03fa8153af604f79dc40b971")
(setf (get third_pkg::myTestMsg :datatype-) "third_pkg/myTestMsg")
(setf (get third_pkg::myTestMsg :definition-)
      "string name
uint16 age
bool handsome
float32 salary
")



(provide :third_pkg/myTestMsg "6ece56ce03fa8153af604f79dc40b971")


