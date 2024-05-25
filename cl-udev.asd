
;;  ██████╗██╗      ██╗   ██╗██████╗ ███████╗██╗   ██╗
;; ██╔════╝██║      ██║   ██║██╔══██╗██╔════╝██║   ██║
;; ██║     ██║█████╗██║   ██║██║  ██║█████╗  ██║   ██║
;; ██║     ██║╚════╝██║   ██║██║  ██║██╔══╝  ╚██╗ ██╔╝
;; ╚██████╗███████╗ ╚██████╔╝██████╔╝███████╗ ╚████╔╝
;;  ╚═════╝╚══════╝  ╚═════╝ ╚═════╝ ╚══════╝  ╚═══╝
(asdf:defsystem #:cl-udev
  :serial t
  :description "Common Lisp libudev ffi integration"
  :author "bmiww <bmiww@bky.one>"
  :license "GPLv3" ;; TODO: Check if the license makes sense for you.
  :version "0.0.1"
  :depends-on (#:cffi)
  :components ((:file "package")
	       (:file "udev")))
