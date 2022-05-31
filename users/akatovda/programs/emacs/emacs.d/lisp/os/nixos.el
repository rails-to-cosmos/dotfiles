(my-project-provide emacs-config)

(defun x-restart (&rest args)
  (shell-command "pkill xmobar")
  (shell-command "xmonad --restart"))

(defun nixos-rebuild ()
  (interactive)
  (save-window-excursion
    (sudo-edit-find-file "/etc/nixos/configuration.nix")
    (let ((nixos-buffer "*nixos*"))
      (async-shell-command "nixos-rebuild switch" nixos-buffer)
      (set-process-sentinel (get-buffer-process nixos-buffer) #'x-restart))))

(defun nix-company-init ()
  (interactive)
  (setq-local company-backends '(company-nixos-options company-files)))

(add-hook 'nix-mode-hook #'nix-company-init)
