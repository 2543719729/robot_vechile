
(cl:in-package :asdf)

(defsystem "bobac3_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :geometry_msgs-msg
               :std_msgs-msg
)
  :components ((:file "_package")
    (:file "ar_pose" :depends-on ("_package_ar_pose"))
    (:file "_package_ar_pose" :depends-on ("_package"))
    (:file "car_cmd" :depends-on ("_package_car_cmd"))
    (:file "_package_car_cmd" :depends-on ("_package"))
    (:file "car_data" :depends-on ("_package_car_data"))
    (:file "_package_car_data" :depends-on ("_package"))
    (:file "joint" :depends-on ("_package_joint"))
    (:file "_package_joint" :depends-on ("_package"))
    (:file "neck_angle" :depends-on ("_package_neck_angle"))
    (:file "_package_neck_angle" :depends-on ("_package"))
    (:file "skeleton" :depends-on ("_package_skeleton"))
    (:file "_package_skeleton" :depends-on ("_package"))
  ))