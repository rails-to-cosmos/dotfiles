(my-project-provide emacs-config)

(require 'company)
(require 'company-quickhelp)
(require 'company-statistics)
(company-quickhelp-mode)
(define-key company-active-map (kbd "C-n") #'company-select-next)
(define-key company-active-map (kbd "C-p") #'company-select-previous)
(global-company-mode t)
