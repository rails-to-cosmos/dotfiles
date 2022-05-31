(my-project-provide emacs-config)

(ob-add-language 'emacs-lisp)
(setq lisp-indent-function 'common-lisp-indent-function)

(require 'slime)
(require 'ts)

(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(setq byte-compile-warnings '(not cl-functions))

(cl-defun emacs-lisp-completion-setup ()
  (setq-local company-backends '(company-elisp)))

(add-hook 'emacs-lisp-mode-hook 'emacs-lisp-completion-setup)

(setq inferior-lisp-program "sbcl")

(cl-defun emacs-lisp-eval-expal ()
  (interactive)
  (save-excursion
    (let ((bounds (expal:bounds)))
      (expal:highlight)

      (goto-char (cdr bounds))
      (eval-last-sexp nil)

      (set-mark (car bounds))
      (goto-char (cdr bounds))
      (indent-for-tab-command)
      (deactivate-mark))))

(define-key emacs-lisp-mode-map (kbd "C-c C-c") 'emacs-lisp-eval-expal)
