(my-project-provide emacs-config)

(require 'all-the-icons)

(defun what-face (pos)
  "Tell me what face used in POS."
  (interactive "d")
  (let ((face (or (get-char-property (point) 'read-face-name)
                  (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))

(defun my--set-font (face &rest params)
  (custom-set-faces (list face (list (list t params)))))

(defun my--adapt-font (&optional font-size font-name)
  (interactive)
  (let ((font-size (or font-size (face-attribute 'default :height)))
        (font-name (or font-name (face-attribute 'default :family)))
        (factor (case system-type
                  ('darwin 10)
                  ('windows-nt 5)
                  (t 0))))

    (my--set-font 'default
                  :slant 'normal
                  :weight 'normal
                  :height font-size
                  :width 'normal
                  :family font-name)

    (set-fontset-font "fontset-default"
                      (cons (decode-char 'ucs #x0400)
                            (decode-char 'ucs #x052F))
                      (if (> factor 0)
                          (font-spec :size (/ font-size factor) :name font-name :family font-name)
                        (font-spec :name font-name :family font-name)))))

(require 'default-text-scale)
(define-key global-map (kbd "C-M-=") #'default-text-scale-increase)
(define-key global-map (kbd "C-M--") #'default-text-scale-decrease)
(default-text-scale-mode 1)
(advice-add #'default-text-scale-increase :after #'my--adapt-font)
(advice-add #'default-text-scale-decrease :after #'my--adapt-font)
;; (my--adapt-font 100 "Jetbrains Mono NL")
;; (my--adapt-font 100 "Font Awesome 9")
(add-hook 'org-mode-hook #'my--adapt-font)
