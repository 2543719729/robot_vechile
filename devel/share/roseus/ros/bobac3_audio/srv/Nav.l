;; Auto-generated. Do not edit!


(when (boundp 'bobac3_audio::Nav)
  (if (not (find-package "BOBAC3_AUDIO"))
    (make-package "BOBAC3_AUDIO"))
  (shadow 'Nav (find-package "BOBAC3_AUDIO")))
(unless (find-package "BOBAC3_AUDIO::NAV")
  (make-package "BOBAC3_AUDIO::NAV"))
(unless (find-package "BOBAC3_AUDIO::NAVREQUEST")
  (make-package "BOBAC3_AUDIO::NAVREQUEST"))
(unless (find-package "BOBAC3_AUDIO::NAVRESPONSE")
  (make-package "BOBAC3_AUDIO::NAVRESPONSE"))

(in-package "ROS")





(defclass bobac3_audio::NavRequest
  :super ros::object
  :slots (_nav_order ))

(defmethod bobac3_audio::NavRequest
  (:init
   (&key
    ((:nav_order __nav_order) "")
    )
   (send-super :init)
   (setq _nav_order (string __nav_order))
   self)
  (:nav_order
   (&optional __nav_order)
   (if __nav_order (setq _nav_order __nav_order)) _nav_order)
  (:serialization-length
   ()
   (+
    ;; string _nav_order
    4 (length _nav_order)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _nav_order
       (write-long (length _nav_order) s) (princ _nav_order s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _nav_order
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _nav_order (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(defclass bobac3_audio::NavResponse
  :super ros::object
  :slots (_position ))

(defmethod bobac3_audio::NavResponse
  (:init
   (&key
    ((:position __position) "")
    )
   (send-super :init)
   (setq _position (string __position))
   self)
  (:position
   (&optional __position)
   (if __position (setq _position __position)) _position)
  (:serialization-length
   ()
   (+
    ;; string _position
    4 (length _position)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _position
       (write-long (length _position) s) (princ _position s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _position
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _position (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(defclass bobac3_audio::Nav
  :super ros::object
  :slots ())

(setf (get bobac3_audio::Nav :md5sum-) "a5777d99dbd597cc68511d66738b3956")
(setf (get bobac3_audio::Nav :datatype-) "bobac3_audio/Nav")
(setf (get bobac3_audio::Nav :request) bobac3_audio::NavRequest)
(setf (get bobac3_audio::Nav :response) bobac3_audio::NavResponse)

(defmethod bobac3_audio::NavRequest
  (:response () (instance bobac3_audio::NavResponse :init)))

(setf (get bobac3_audio::NavRequest :md5sum-) "a5777d99dbd597cc68511d66738b3956")
(setf (get bobac3_audio::NavRequest :datatype-) "bobac3_audio/NavRequest")
(setf (get bobac3_audio::NavRequest :definition-)
      "string nav_order
---
string position

")

(setf (get bobac3_audio::NavResponse :md5sum-) "a5777d99dbd597cc68511d66738b3956")
(setf (get bobac3_audio::NavResponse :datatype-) "bobac3_audio/NavResponse")
(setf (get bobac3_audio::NavResponse :definition-)
      "string nav_order
---
string position

")



(provide :bobac3_audio/Nav "a5777d99dbd597cc68511d66738b3956")


