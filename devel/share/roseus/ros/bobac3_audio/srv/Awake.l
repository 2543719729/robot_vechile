;; Auto-generated. Do not edit!


(when (boundp 'bobac3_audio::Awake)
  (if (not (find-package "BOBAC3_AUDIO"))
    (make-package "BOBAC3_AUDIO"))
  (shadow 'Awake (find-package "BOBAC3_AUDIO")))
(unless (find-package "BOBAC3_AUDIO::AWAKE")
  (make-package "BOBAC3_AUDIO::AWAKE"))
(unless (find-package "BOBAC3_AUDIO::AWAKEREQUEST")
  (make-package "BOBAC3_AUDIO::AWAKEREQUEST"))
(unless (find-package "BOBAC3_AUDIO::AWAKERESPONSE")
  (make-package "BOBAC3_AUDIO::AWAKERESPONSE"))

(in-package "ROS")





(defclass bobac3_audio::AwakeRequest
  :super ros::object
  :slots (_text ))

(defmethod bobac3_audio::AwakeRequest
  (:init
   (&key
    ((:text __text) "")
    )
   (send-super :init)
   (setq _text (string __text))
   self)
  (:text
   (&optional __text)
   (if __text (setq _text __text)) _text)
  (:serialization-length
   ()
   (+
    ;; string _text
    4 (length _text)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; string _text
       (write-long (length _text) s) (princ _text s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; string _text
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _text (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(defclass bobac3_audio::AwakeResponse
  :super ros::object
  :slots (_awake_flag ))

(defmethod bobac3_audio::AwakeResponse
  (:init
   (&key
    ((:awake_flag __awake_flag) nil)
    )
   (send-super :init)
   (setq _awake_flag __awake_flag)
   self)
  (:awake_flag
   (&optional (__awake_flag :null))
   (if (not (eq __awake_flag :null)) (setq _awake_flag __awake_flag)) _awake_flag)
  (:serialization-length
   ()
   (+
    ;; bool _awake_flag
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; bool _awake_flag
       (if _awake_flag (write-byte -1 s) (write-byte 0 s))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; bool _awake_flag
     (setq _awake_flag (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;;
   self)
  )

(defclass bobac3_audio::Awake
  :super ros::object
  :slots ())

(setf (get bobac3_audio::Awake :md5sum-) "346f56948fa329d395224adefd3ff2c1")
(setf (get bobac3_audio::Awake :datatype-) "bobac3_audio/Awake")
(setf (get bobac3_audio::Awake :request) bobac3_audio::AwakeRequest)
(setf (get bobac3_audio::Awake :response) bobac3_audio::AwakeResponse)

(defmethod bobac3_audio::AwakeRequest
  (:response () (instance bobac3_audio::AwakeResponse :init)))

(setf (get bobac3_audio::AwakeRequest :md5sum-) "346f56948fa329d395224adefd3ff2c1")
(setf (get bobac3_audio::AwakeRequest :datatype-) "bobac3_audio/AwakeRequest")
(setf (get bobac3_audio::AwakeRequest :definition-)
      "string text
---
bool awake_flag

")

(setf (get bobac3_audio::AwakeResponse :md5sum-) "346f56948fa329d395224adefd3ff2c1")
(setf (get bobac3_audio::AwakeResponse :datatype-) "bobac3_audio/AwakeResponse")
(setf (get bobac3_audio::AwakeResponse :definition-)
      "string text
---
bool awake_flag

")



(provide :bobac3_audio/Awake "346f56948fa329d395224adefd3ff2c1")


