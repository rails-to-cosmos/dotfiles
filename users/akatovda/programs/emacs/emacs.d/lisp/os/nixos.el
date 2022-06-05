(my-project-provide emacs-config)

(require 'nix-company)

(defvar nixos-buffer  "*nixos*")

(defun nixos-rebuild ()
  (interactive)
  (save-window-excursion
    (sudo-edit-find-file "/etc/nixos/configuration.nix")
    (async-shell-command "nixos-rebuild switch" nixos-buffer))
  ;; (switch-to-buffer-other-window nixos-buffer)
  ;; (other-window 1)
  )

(defun nix-company-init ()
  (interactive)
  (setq-local company-backends '(company-nixos-options company-files)))

(add-hook 'nix-mode-hook #'nix-company-init)
