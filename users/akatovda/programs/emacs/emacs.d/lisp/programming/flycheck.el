(my-project-provide emacs-config)

(setq flycheck-check-syntax-automatically '(save idle-change mode-enabled)
      flycheck-idle-change-delay 5
      flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list)

(add-hook 'prog-mode-hook 'flycheck-mode)
