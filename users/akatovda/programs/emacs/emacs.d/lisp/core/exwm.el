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

(defun exwm-minikube-dashboard ()
  (interactive)
  (start-process "minikube-dashboard" "*minikube-dashboard*" "minikube" "dashboard"))

(setq exwm-input-global-keys
      (list (cons (kbd "C-M-<SPC>") #'exwm-rofi)
            (cons (kbd "M-<SPC>") #'exwm-switch-layout)
            (cons (kbd "<f7>") #'exwm-brightness-down)
            (cons (kbd "<f8>") #'exwm-brightness-up)))
