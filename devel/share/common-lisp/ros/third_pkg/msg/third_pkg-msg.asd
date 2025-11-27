
(cl:in-package :asdf)

(defsystem "third_pkg-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "myTestMsg" :depends-on ("_package_myTestMsg"))
    (:file "_package_myTestMsg" :depends-on ("_package"))
  ))