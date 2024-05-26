
;;  ██████╗██╗      ██╗   ██╗██████╗ ███████╗██╗   ██╗
;; ██╔════╝██║      ██║   ██║██╔══██╗██╔════╝██║   ██║
;; ██║     ██║█████╗██║   ██║██║  ██║█████╗  ██║   ██║
;; ██║     ██║╚════╝██║   ██║██║  ██║██╔══╝  ╚██╗ ██╔╝
;; ╚██████╗███████╗ ╚██████╔╝██████╔╝███████╗ ╚████╔╝
;;  ╚═════╝╚══════╝  ╚═════╝ ╚═════╝ ╚══════╝  ╚═══╝
;; NOTE: Monitor from here:
;; https://github.com/systemd/systemd/blob/main/src/libudev/libudev-monitor.c
;; NOTE: Device parsing from here:
;; https://github.com/systemd/systemd/blob/main/src/libudev/libudev-device.c
(in-package :cl-udev)

(define-foreign-library libudev (t (:default "libudev")))
(use-foreign-library libudev)

;; ┌┬┐┌─┐┌─┐┌┬┐┬─┐┬ ┬┌─┐┌┬┐┌─┐
;; │││├┤ └─┐ │ ├┬┘│ ││   │ └─┐
;; ┴ ┴└─┘└─┘ ┴ ┴└─└─┘└─┘ ┴ └─┘
(defstruct dev
  ptr
  dev-t
  driver
  parent
  dev-type
  subsystem
  dev-path
  sys-path
  sys-name
  sys-num
  dev-node
  action
  time-since-init
  is-init)

;; ┌─┐┌─┐┌┬┐┬─┐┬ ┬┌─┐┌┬┐┌─┐
;; │  └─┐ │ ├┬┘│ ││   │ └─┐
;; └─┘└─┘ ┴ ┴└─└─┘└─┘ ┴ └─┘
(defcstruct udev-monitor
  "This is an opaque struct which shouldn't be accessed directly."
  (udev :pointer)
  (n-ref :uint)
  (sd-device-monitor :pointer))

;; ┌─┐┌─┐┬ ┬┌┐┌
;; │  ├┤ │ ││││
;; └─┘└  └─┘┘└┘
(defcfun ("udev_new" %new) :pointer
  "Create a new udev object.")

;; device
;; TODO: Didn't add set_sysattr

(defcfun ("udev_device_has_tag" %device-has-tag) :int (device :pointer) (tag :string))
(defcfun ("udev_device_has_current_tag" %device-has-current-tag) :int (device :pointer) (tag :string))

(defcfun ("udev_device_get_parent" %device-get-parent) :pointer (device :pointer))
(defcfun ("udev_device_get_devnum" %device-get-devnum) :uint64 (device :pointer))
(defcfun ("udev_device_get_driver" %device-get-driver) :string (device :pointer))
(defcfun ("udev_device_get_devtype" %device-get-devtype) :string (device :pointer))
(defcfun ("udev_device_get_subsystem" %device-get-subsystem) :string (device :pointer))
(defcfun ("udev_device_get_devpath" %device-get-devpath) :string (device :pointer))
(defcfun ("udev_device_get_syspath" %device-get-syspath) :string (device :pointer))
(defcfun ("udev_device_get_sysname" %device-get-sysname) :string (device :pointer))
(defcfun ("udev_device_get_sysnum" %device-get-sysnum) :string (device :pointer))
(defcfun ("udev_device_get_devnode" %device-get-devnode) :string (device :pointer))
(defcfun ("udev_device_get_action" %device-get-action) :string (device :pointer))
(defcfun ("udev_device_get_usec_since_initialized" %device-get-usec-since-initialized) :uint64 (device :pointer))
;; TODO: 1 is true 0 is false
(defcfun ("udev_device_get_is_initialized" %device-get-is-initialized) :int (device :pointer))

(defcfun ("udev_device_get_property_value" %device-get-property-value) :string (device :pointer) (key :string))
(defcfun ("udev_device_get_sysattr_value" %device-get-sysattr-value) :string (device :pointer) (sysattr :string))



;; TODO: Replace pointer with the udev_list_entry struct
;; TODO: Do not expose - build a function that collects the list
;; TODO: udev_device_get_devlinks_list_entry

;; TODO: Replace pointer with the udev_list_entry struct
;; TODO: Do not expose - build a function that collects the list
;; NOTE: Combines with %device-get-sysattr-value
(defcfun ("udev_device_get_sysattr_list_entry" %device-get-sysattr-list-entry) :pointer (device :pointer))

;; TODO: Replace pointer with the udev_list_entry struct
;; TODO: Do not expose - build a function that collects the list
;; NOTE: Combines with %device-get-property-value
(defcfun ("udev_device_get_properties_list_entry" %device-get-properties-list-entry) :pointer (device :pointer))

;; TODO: Replace pointer with the udev_list_entry struct
;; TODO: Do not expose - build a function that collects the list
;; TODO: The tag can be retrieved on each item via: udev_list_entry_get_name
(defcfun ("udev_device_get_tags_list_entry" %device-get-tags-list-entry) :pointer (device :pointer))


;; monitor
(defcfun ("udev_monitor_new_from_netlink" %monitor-new-from-netlink) udev-monitor
  (udev :pointer) (name :string))

(defcfun ("udev_monitor_get_fd" %monitor-get-fd) :int
  (monitor :pointer))

(defcfun ("udev_monitor_enable_receiving" %monitor-enable-receiving) :int
  (monitor :pointer))

(defcfun ("udev_monitor_receive_device" %monitor-receive-device) :pointer
  (monitor :pointer))


;; ┌─┐┬ ┬┌┐┌
;; ├┤ │ ││││
;; └  └─┘┘└┘
(defun udev-new () (%new))
(defun monitor-kernel (udev) (%monitor-new-from-netlink udev "kernel"))
(defun monitor-udev (udev)
  (let ((result (%monitor-new-from-netlink udev "udev")))
    (when (null-pointer-p result) (error "Failed to create udev monitor"))
    result))

(defun get-fd (monitor) (%monitor-get-fd monitor))

(defun receive-device (monitor)
  (let ((device (%monitor-receive-device monitor)))
    (if (null-pointer-p device) nil (mk-dev device))))


;; ┌─┐┌─┐┬─┐┌─┐┌─┐┬─┐┌─┐
;; ├─┘├─┤├┬┘└─┐├┤ ├┬┘└─┐
;; ┴  ┴ ┴┴└─└─┘└─┘┴└─└─┘
(defun mk-dev (ptr)
  (make-dev :ptr ptr
	    :dev-t (%device-get-devnum ptr)
	    :driver (%device-get-driver ptr)
	    :dev-type (%device-get-devtype ptr)
	    :subsystem (%device-get-subsystem ptr)
	    :dev-path (%device-get-devpath ptr)
	    :sys-path (%device-get-syspath ptr)
	    :sys-name (%device-get-sysname ptr)
	    :sys-num (%device-get-sysnum ptr)
	    :dev-node (%device-get-devnode ptr)
	    :action (%device-get-action ptr)
	    :time-since-init (%device-get-usec-since-initialized ptr)
	    :is-init (%device-get-is-initialized ptr)))

(defun fill-parent (dev)
  (let ((parent-ptr (dev-ptr dev)))
    (setf (dev-parent dev) (mk-dev (%device-get-parent parent-ptr)))))
