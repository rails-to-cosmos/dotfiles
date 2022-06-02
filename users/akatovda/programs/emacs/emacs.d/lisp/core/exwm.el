(my-project-provide emacs-config)

(require 'exwm)
(require 'exwm-config)

(exwm-enable)
(wallpaper-cycle-mode)

(set-frame-parameter nil 'alpha '(70 70))
(add-to-list 'default-frame-alist '(alpha 70 70))

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
