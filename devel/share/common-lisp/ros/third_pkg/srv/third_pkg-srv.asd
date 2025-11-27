
(cl:in-package :asdf)

(defsystem "third_pkg-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "myTestSrv" :depends-on ("_package_myTestSrv"))
    (:file "_package_myTestSrv" :depends-on ("_package"))
  ))