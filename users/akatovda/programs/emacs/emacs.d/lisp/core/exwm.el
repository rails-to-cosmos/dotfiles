(my-project-provide emacs-config)

(require 'exwm)
(require 'exwm-config)

(exwm-enable)

(defun exwm-auto-buffer-name ()
  (interactive)
  (let* ((buffer (current-buffer))
         (id (exwm--buffer->id buffer)))
    (when id
      (let ((getter (make-instance 'xcb:ewmh:get-_NET_WM_NAME :window id)))
        (rename-buffer
         (concat "*exwm:"
                 (slot-value (xcb:+request-unchecked+reply exwm--connection getter) 'value)
                 "*")
         t)))))

(add-hook 'exwm-mode-hook #'exwm-auto-buffer-name)

(defun exwm-rofi ()
  (interactive)
  (call-process "rofi" nil nil nil "-show"))

(defun exwm-switch-layout ()
  (interactive)
  (call-process "switch-layout"))

(defun exwm-brightness-down ()
  (interactive)
  (call-process "brightness" nil nil nil "Down"))

(defun exwm-brightness-up ()
  (interactive)
  (call-process "brightness" nil nil nil "Up"))

(defun exwm-reboot ()
  (interactive)
  (call-process "reboot"))

(defun exwm-shutdown ()
  (interactive)
  (call-process "shutdown" nil nil nil "now"))

(defun exwm-minikube-dashboard ()
  (interactive)
  (start-process "minikube-dashboard" "*minikube-dashboard*" "minikube" "dashboard"))

(defun exwm-volume-up ()
  (interactive)
  (start-process "volume-up" "*volume-up*" "pactl" "--" "set-sink-volume" "0" "+10%"))

(defun exwm-volume-down ()
  (interactive)
  (start-process "volume-down" "*volume-down*" "pactl" "--" "set-sink-volume" "0" "-10%"))

(defun exwm-volume-mute ()
  (interactive)
  (start-process "volume-mute" "*volume-mute*" "pactl" "--" "set-sink-volume" "0" "0%"))

(setq exwm-input-global-keys
      (list (cons (kbd "C-M-<SPC>") #'exwm-rofi)
            (cons (kbd "M-<SPC>") #'exwm-switch-layout)
            (cons (kbd "<f7>") #'exwm-brightness-down)
            (cons (kbd "<f8>") #'exwm-brightness-up)
            (cons (kbd "<f1>") #'exwm-volume-mute)
            (cons (kbd "<f2>") #'exwm-volume-down)
            (cons (kbd "<f3>") #'exwm-volume-up)))
