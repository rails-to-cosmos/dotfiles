(my-project-provide emacs-config)

(require 'rainbow-mode)
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook #'rainbow-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
