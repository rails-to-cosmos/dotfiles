(require 'eshell)
(require 'esh-mode)

(defun eshell-compl-space ()
  (interactive)
  (cond
    ((looking-back "cd" 1)
     (condition-case exc
         (progn
           (insert " ")
           (sit-for 0.05)
           (progn
             (insert (shell-quote-argument (read-directory-name "Choose directory: ")))
             (eshell-send-input)
             (insert "ls -la")
             (eshell-send-input)))
       ('quit
        (eshell-kill-input))))
    ((looking-back "\\./" 1)
     (condition-case exc
         (progn
           (sit-for 0.05)
           (insert (shell-quote-argument (file-relative-name (read-file-name "Choose file or directory: ")))))
       ('quit )))
    (t (insert " "))))

(defun eshell-compl-back ()
  (interactive)
  (cond
    ((or (equal (point-marker) eshell-last-input-start)
         (looking-back "λ " 1))
     (setq eshell-last-input-start (point-marker)))
    (t (delete-backward-char 1))))

(defun eshell-set-keys ()
  (define-key eshell-mode-map (kbd "<SPC>") 'eshell-compl-space)
  (define-key eshell-mode-map (kbd "<backspace>") 'eshell-compl-back))

(add-hook 'eshell-first-time-mode-hook 'eshell-set-keys)

(provide-me)
