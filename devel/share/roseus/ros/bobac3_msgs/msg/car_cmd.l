;; Auto-generated. Do not edit!


(when (boundp 'bobac3_msgs::car_cmd)
  (if (not (find-package "BOBAC3_MSGS"))
    (make-package "BOBAC3_MSGS"))
  (shadow 'car_cmd (find-package "BOBAC3_MSGS")))
(unless (find-package "BOBAC3_MSGS::CAR_CMD")
  (make-package "BOBAC3_MSGS::CAR_CMD"))

(in-package "ROS")
;;//! \htmlinclude car_cmd.msg.html


(defclass bobac3_msgs::car_cmd
  :super ros::object
  :slots (_speed _been ))

(defmethod bobac3_msgs::car_cmd
  (:init
   (&key
    ((:speed __speed) (make-array 0 :initial-element 0.0 :element-type :float))
    ((:been __been) 0)
    )
   (send-super :init)
   (setq _speed __speed)
   (setq _been (round __been))
   self)
  (:speed
   (&optional __speed)
   (if __speed (setq _speed __speed)) _speed)
  (:been
   (&optional __been)
   (if __been (setq _been __been)) _been)
  (:serialization-length
   ()
   (+
    ;; float64[] _speed
    (* 8    (length _speed)) 4
    ;; uint16 _been
    2
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float64[] _speed
     (write-long (length _speed) s)
     (dotimes (i (length _speed))
       (sys::poke (elt _speed i) (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
       )
     ;; uint16 _been
       (write-word _been s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float64[] _speed
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _speed (instantiate float-vector n))
     (dotimes (i n)
     (setf (elt _speed i) (sys::peek buf ptr- :double)) (incf ptr- 8)
     ))
   ;; uint16 _been
     (setq _been (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;;
   self)
  )

(setf (get bobac3_msgs::car_cmd :md5sum-) "5a353eb45570aedb9fa4844cc33fae72")
(setf (get bobac3_msgs::car_cmd :datatype-) "bobac3_msgs/car_cmd")
(setf (get bobac3_msgs::car_cmd :definition-)
      "float64[] speed
uint16 been

")



(provide :bobac3_msgs/car_cmd "5a353eb45570aedb9fa4844cc33fae72")


