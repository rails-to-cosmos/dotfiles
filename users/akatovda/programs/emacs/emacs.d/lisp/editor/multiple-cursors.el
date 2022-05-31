(my-project-provide emacs-config)

(require 'multiple-cursors)
(define-key global-map (kbd "C-<") #'mc/mark-previous-like-this)
(define-key global-map (kbd "C->") #'mc/mark-next-like-this)
(define-key global-map (kbd "C-+") #'mc/mark-all-like-this)
