;; Auto-generated. Do not edit!


(when (boundp 'bobac3_msgs::car_data)
  (if (not (find-package "BOBAC3_MSGS"))
    (make-package "BOBAC3_MSGS"))
  (shadow 'car_data (find-package "BOBAC3_MSGS")))
(unless (find-package "BOBAC3_MSGS::CAR_DATA")
  (make-package "BOBAC3_MSGS::CAR_DATA"))

(in-package "ROS")
;;//! \htmlinclude car_data.msg.html


(defclass bobac3_msgs::car_data
  :super ros::object
  :slots (_speed _crash _infrared _ultrasonic _smoke _power_voltage _mpu _tempareture _humidity ))

(defmethod bobac3_msgs::car_data
  (:init
   (&key
    ((:speed __speed) (make-array 0 :initial-element 0.0 :element-type :float))
    ((:crash __crash) (make-array 0 :initial-element 0 :element-type :integer))
    ((:infrared __infrared) (make-array 0 :initial-element 0 :element-type :integer))
    ((:ultrasonic __ultrasonic) (make-array 0 :initial-element 0 :element-type :integer))
    ((:smoke __smoke) 0)
    ((:power_voltage __power_voltage) 0)
    ((:mpu __mpu) (make-array 0 :initial-element 0.0 :element-type :float))
    ((:tempareture __tempareture) 0.0)
    ((:humidity __humidity) 0.0)
    )
   (send-super :init)
   (setq _speed __speed)
   (setq _crash __crash)
   (setq _infrared __infrared)
   (setq _ultrasonic __ultrasonic)
   (setq _smoke (round __smoke))
   (setq _power_voltage (round __power_voltage))
   (setq _mpu __mpu)
   (setq _tempareture (float __tempareture))
   (setq _humidity (float __humidity))
   self)
  (:speed
   (&optional __speed)
   (if __speed (setq _speed __speed)) _speed)
  (:crash
   (&optional __crash)
   (if __crash (setq _crash __crash)) _crash)
  (:infrared
   (&optional __infrared)
   (if __infrared (setq _infrared __infrared)) _infrared)
  (:ultrasonic
   (&optional __ultrasonic)
   (if __ultrasonic (setq _ultrasonic __ultrasonic)) _ultrasonic)
  (:smoke
   (&optional __smoke)
   (if __smoke (setq _smoke __smoke)) _smoke)
  (:power_voltage
   (&optional __power_voltage)
   (if __power_voltage (setq _power_voltage __power_voltage)) _power_voltage)
  (:mpu
   (&optional __mpu)
   (if __mpu (setq _mpu __mpu)) _mpu)
  (:tempareture
   (&optional __tempareture)
   (if __tempareture (setq _tempareture __tempareture)) _tempareture)
  (:humidity
   (&optional __humidity)
   (if __humidity (setq _humidity __humidity)) _humidity)
  (:serialization-length
   ()
   (+
    ;; float64[] _speed
    (* 8    (length _speed)) 4
    ;; uint16[] _crash
    (* 2    (length _crash)) 4
    ;; uint16[] _infrared
    (* 2    (length _infrared)) 4
    ;; uint16[] _ultrasonic
    (* 2    (length _ultrasonic)) 4
    ;; uint16 _smoke
    2
    ;; uint16 _power_voltage
    2
    ;; float32[] _mpu
    (* 4    (length _mpu)) 4
    ;; float32 _tempareture
    4
    ;; float32 _humidity
    4
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
     ;; uint16[] _crash
     (write-long (length _crash) s)
     (dotimes (i (length _crash))
       (write-word (elt _crash i) s)
       )
     ;; uint16[] _infrared
     (write-long (length _infrared) s)
     (dotimes (i (length _infrared))
       (write-word (elt _infrared i) s)
       )
     ;; uint16[] _ultrasonic
     (write-long (length _ultrasonic) s)
     (dotimes (i (length _ultrasonic))
       (write-word (elt _ultrasonic i) s)
       )
     ;; uint16 _smoke
       (write-word _smoke s)
     ;; uint16 _power_voltage
       (write-word _power_voltage s)
     ;; float32[] _mpu
     (write-long (length _mpu) s)
     (dotimes (i (length _mpu))
       (sys::poke (elt _mpu i) (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
       )
     ;; float32 _tempareture
       (sys::poke _tempareture (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _humidity
       (sys::poke _humidity (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
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
   ;; uint16[] _crash
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _crash (instantiate integer-vector n))
     (dotimes (i n)
     (setf (elt _crash i) (sys::peek buf ptr- :short)) (incf ptr- 2)
     ))
   ;; uint16[] _infrared
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _infrared (instantiate integer-vector n))
     (dotimes (i n)
     (setf (elt _infrared i) (sys::peek buf ptr- :short)) (incf ptr- 2)
     ))
   ;; uint16[] _ultrasonic
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _ultrasonic (instantiate integer-vector n))
     (dotimes (i n)
     (setf (elt _ultrasonic i) (sys::peek buf ptr- :short)) (incf ptr- 2)
     ))
   ;; uint16 _smoke
     (setq _smoke (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; uint16 _power_voltage
     (setq _power_voltage (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; float32[] _mpu
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _mpu (instantiate float-vector n))
     (dotimes (i n)
     (setf (elt _mpu i) (sys::peek buf ptr- :float)) (incf ptr- 4)
     ))
   ;; float32 _tempareture
     (setq _tempareture (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _humidity
     (setq _humidity (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get bobac3_msgs::car_data :md5sum-) "2cce16e01821bbf3f6a71093439b392f")
(setf (get bobac3_msgs::car_data :datatype-) "bobac3_msgs/car_data")
(setf (get bobac3_msgs::car_data :definition-)
      "float64[] speed
uint16[] crash
uint16[] infrared
uint16[] ultrasonic
uint16 smoke
uint16 power_voltage
float32[] mpu
float32 tempareture
float32 humidity

")



(provide :bobac3_msgs/car_data "2cce16e01821bbf3f6a71093439b392f")


