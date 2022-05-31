(my-project-provide emacs-config)

(defun sanityinc/no-trailing-whitespace ()
  "Turn off display of trailing whitespace in this buffer."
  (setq show-trailing-whitespace nil))

;; But don't show trailing whitespace in SQLi, inf-ruby etc.
(dolist (hook '(special-mode-hook
                Info-mode-hook
                eww-mode-hook
                term-mode-hook
                comint-mode-hook
                compilation-mode-hook
                twittering-mode-hook
                minibuffer-setup-hook
                eshell-mode-hook
                prog-mode-hook))
  (add-hook hook #'sanityinc/no-trailing-whitespace))

(transient-mark-mode)

(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'horizontal-scroll-bar-mode) (horizontal-scroll-bar-mode -1))

(setq comint-prompt-read-only t)
(add-hook 'comint-output-filter-functions #'comint-strip-ctrl-m)

(require 'whitespace-cleanup-mode)
(global-whitespace-cleanup-mode t)
(define-key global-map (kbd "RET") 'newline-and-indent)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(when (fboundp 'global-prettify-symbols-mode)
  (global-prettify-symbols-mode))

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; http://pragmaticemacs.com/emacs/make-emacs-a-bit-quieter/
(advice-add #'display-startup-echo-area-message :override #'ignore)

(fset 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode 1)
(blink-cursor-mode 0)

(setq-default case-fold-search t
	      compilation-scroll-output t
	      ediff-split-window-function 'split-window-horizontally
	      ediff-window-setup-function 'ediff-setup-windows-plain
	      grep-highlight-matches t
	      grep-scroll-output t
	      make-backup-files nil
	      mouse-yank-at-point t
	      save-interprogram-paste-before-kill t
	      scroll-preserve-screen-position 'always
	      set-mark-command-repeat-pop t
	      tooltip-delay 1.5
	      truncate-lines nil
	      truncate-partial-width-windows nil
	      indent-tabs-mode nil
	      x-use-underline-position-properties t
	      underline-minimum-offset 3
	      inhibit-startup-screen t
	      cursor-type 'box
	      split-width-threshold 160
	      split-height-threshold nil
	      frame-title-format '((:eval (if (buffer-file-name) (abbreviate-file-name (buffer-file-name)) "%b")))
	      buffers-menu-max-size 30)

(defun delete-this-file ()
  "Delete the current file, and kill the buffer."
  (interactive)
  (or (buffer-file-name) (user-error "No file is currently being edited"))
  (when (yes-or-no-p (format "Really delete '%s'?"
                             (file-name-nondirectory buffer-file-name)))
    (delete-file (buffer-file-name))
    (kill-this-buffer)))
