
(cl:in-package :asdf)

(defsystem "bobac3_msgs-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "Neck" :depends-on ("_package_Neck"))
    (:file "_package_Neck" :depends-on ("_package"))
    (:file "SetCharge" :depends-on ("_package_SetCharge"))
    (:file "_package_SetCharge" :depends-on ("_package"))
    (:file "SetRelativeMove" :depends-on ("_package_SetRelativeMove"))
    (:file "_package_SetRelativeMove" :depends-on ("_package"))
    (:file "track" :depends-on ("_package_track"))
    (:file "_package_track" :depends-on ("_package"))
  ))