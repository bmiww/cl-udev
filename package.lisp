
;;  ██████╗██╗      ██╗   ██╗██████╗ ███████╗██╗   ██╗
;; ██╔════╝██║      ██║   ██║██╔══██╗██╔════╝██║   ██║
;; ██║     ██║█████╗██║   ██║██║  ██║█████╗  ██║   ██║
;; ██║     ██║╚════╝██║   ██║██║  ██║██╔══╝  ╚██╗ ██╔╝
;; ╚██████╗███████╗ ╚██████╔╝██████╔╝███████╗ ╚████╔╝
;;  ╚═════╝╚══════╝  ╚═════╝ ╚═════╝ ╚══════╝  ╚═══╝
(defpackage :cl-udev
  (:use :cl :cffi)
  (:nicknames :udev)
  (:export
   udev-new
   monitor-udev
   receive-device
   get-fd

   ;; device
   dev-subsystem
   dev-sys-name
   dev-action
   dev-dev-node
   ))
