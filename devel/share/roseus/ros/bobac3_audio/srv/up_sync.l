;; Auto-generated. Do not edit!


(when (boundp 'bobac3_audio::up_sync)
  (if (not (find-package "BOBAC3_AUDIO"))
    (make-package "BOBAC3_AUDIO"))
  (shadow 'up_sync (find-package "BOBAC3_AUDIO")))
(unless (find-package "BOBAC3_AUDIO::UP_SYNC")
  (make-package "BOBAC3_AUDIO::UP_SYNC"))
(unless (find-package "BOBAC3_AUDIO::UP_SYNCREQUEST")
  (make-package "BOBAC3_AUDIO::UP_SYNCREQUEST"))
(unless (find-package "BOBAC3_AUDIO::UP_SYNCRESPONSE")
  (make-package "BOBAC3_AUDIO::UP_SYNCRESPONSE"))

(in-package "ROS")





(defclass bobac3_audio::up_syncRequest
  :super ros::object
  :slots ())

(defmethod bobac3_audio::up_syncRequest
  (:init
   (&key
    )
   (send-super :init)
   self)
  (:serialization-length
   ()
   (+
    0
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;;
   self)
  )

(defclass bobac3_audio::up_syncResponse
  :super ros::object
  :slots (_result ))

(defmethod bobac3_audio::up_syncResponse
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

(defclass bobac3_audio::up_sync
  :super ros::object
  :slots ())

(setf (get bobac3_audio::up_sync :md5sum-) "eb13ac1f1354ccecb7941ee8fa2192e8")
(setf (get bobac3_audio::up_sync :datatype-) "bobac3_audio/up_sync")
(setf (get bobac3_audio::up_sync :request) bobac3_audio::up_syncRequest)
(setf (get bobac3_audio::up_sync :response) bobac3_audio::up_syncResponse)

(defmethod bobac3_audio::up_syncRequest
  (:response () (instance bobac3_audio::up_syncResponse :init)))

(setf (get bobac3_audio::up_syncRequest :md5sum-) "eb13ac1f1354ccecb7941ee8fa2192e8")
(setf (get bobac3_audio::up_syncRequest :datatype-) "bobac3_audio/up_syncRequest")
(setf (get bobac3_audio::up_syncRequest :definition-)
      "---
bool result

")

(setf (get bobac3_audio::up_syncResponse :md5sum-) "eb13ac1f1354ccecb7941ee8fa2192e8")
(setf (get bobac3_audio::up_syncResponse :datatype-) "bobac3_audio/up_syncResponse")
(setf (get bobac3_audio::up_syncResponse :definition-)
      "---
bool result

")



(provide :bobac3_audio/up_sync "eb13ac1f1354ccecb7941ee8fa2192e8")


