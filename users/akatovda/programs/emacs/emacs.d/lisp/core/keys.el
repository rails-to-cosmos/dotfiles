(my-project-provide emacs-config)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'eval-expression 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'list-threads 'disabled nil)

(define-key global-map (kbd "C-x y d c") #'desktop-clear)
(define-key global-map (kbd "C-x y f f") #'toggle-frame-maximized)
(define-key global-map (kbd "C-x k") #'kill-this-buffer)
(define-key global-map (kbd "C-x y e") #'eshell)

(define-key global-map (kbd "C-x f") #'projectile-find-file)
(define-key global-map (kbd "C-c r") #'projectile-ripgrep)

(define-key global-map (kbd "C-x C-d") 'dired-switch-buffers)
(define-key global-map (kbd "C-x d") 'dired-default-directory)
(define-key dired-mode-map "/" 'dired-narrow-fuzzy)
(define-key dired-mode-map "~" '(lambda () (interactive) (dired "~")))
(define-key dired-mode-map (kbd "C-w") 'diredp-copy-abs-filenames-as-kill)
(define-key dired-mode-map (kbd "!") #'dired:xdg-open-marked-files)
(define-key dired-mode-map (kbd "<DEL>") 'dired-up-please)
(define-key dired-mode-map (kbd "<RET>") 'dired-down-please)
(define-key dired-mode-map (kbd "C-c C-p") 'wdired-change-to-wdired-mode)

(defun rofi ()
  (interactive)
  (call-process "rofi" nil nil nil "-show"))

(defun switch-layout ()
  (interactive)
  (call-process "switch-layout"))

(setq exwm-input-global-keys
      (list (cons (kbd "C-M-<SPC>") #'rofi)
            (cons (kbd "M-<SPC>") #'switch-layout)))

(require 'reverse-im)
(reverse-im-activate "russian-computer")

;; (use-package which-key
;;   :config
;;   (which-key-mode t)
;;   (which-key-setup-side-window-bottom))
