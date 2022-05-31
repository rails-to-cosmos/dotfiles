(my-project-provide emacs-config)

(require 'exec-path-from-shell)
(require 'eshell-prompt-extras)

(when (memq window-system '(mac ns gnulinux x))
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "SSH_AGENT_PID")
  (exec-path-from-shell-copy-env "SSH_AUTH_SOCK"))

(with-eval-after-load 'em-alias
    ;;; TODO: This conflicts with `evil-define-key' during the initialization of
    ;;; the first eshell session: the map in insert-mode will not take the changes
    ;;; into account. Going to normal mode and back to insert mode works.
  (eshell-read-aliases-list)
  (dolist
      (alias
       '(("l" "ls -l $*")
         ("la" "ls -lAh $*")
         ("ll" "ls -lh $*")
         ("cp" "*cp -i $*")
         ("mv" "*mv -i $*")
         ("mkdir" "*mkdir -p $*")
         ("mkcd" "*mkdir -p $* && cd $1")))
    (add-to-list 'eshell-command-aliases-list alias))
  (eshell-write-aliases-list))

(autoload 'epe-theme-lambda "eshell-prompt-extras")
