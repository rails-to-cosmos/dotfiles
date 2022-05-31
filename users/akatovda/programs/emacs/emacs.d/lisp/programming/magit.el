(my-project-provide emacs-config)

(require 'magit)
(define-key global-map (kbd "C-x g s") #'magit-status)
