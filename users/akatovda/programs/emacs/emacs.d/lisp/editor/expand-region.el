(my-project-provide emacs-config)

(require 'expand-region)

(setq shift-select-mode nil)

;; from http://endlessparentheses.com/where-do-you-bind-expand-region.html
(global-set-key (kbd "M-2") #'er/expand-region)
