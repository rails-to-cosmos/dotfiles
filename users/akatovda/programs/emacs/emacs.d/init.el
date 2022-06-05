;;; init.el --- my emacs configuration
;;; Commentary:
;;; Code:

(require 'custom)
(require 'package)

(setq package-enable-at-startup t
      package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package f)
(use-package load-relative)
(use-package highlight)

(require 'my-project (f-join user-emacs-directory "lisp" "my-project.el"))

(defvar emacs-config
  (my-project :name "my-emacs-config"
              :root (file-name-directory (__FILE__))))

;; (unicode-fonts-setup)

(my-project-require emacs-config
  ;; aes
  ;; aio
  ;; all-the-icons
  ;; anaconda-mode
  ;; auto-virtualenvwrapper
  ;; bind-key

  ;; dash
  ;; commander
  ;; git
  ;; epl
  ;; shut-up

  ;; cask
  ;; cask-mode
  ;; cider
  ;; clojure-mode
  ;; company
  ;; company-anaconda
  ;; company-nixos-options
  ;; company-quickhelp
  ;; company-statistics
  ;; consult
  ;; danneskjold-theme
  ;; dante
  ;; default-text-scale
  ;; diminish
  ;; dired-narrow
  ;; dired-rainbow
  ;; docker
  ;; dockerfile-mode
  ;; elfeed
  ;; eshell-prompt-extras
  ;; exec-path-from-shell
  ;; expand-region
  ;; exwm
  ;; f
  ;; feature-mode
  ;; firestarter
  ;; flycheck
  ;; flycheck-indicator
  ;; flycheck-pycheckers
  ;; font-utils
  ;; haskell-mode
  ;; highlight
  ;; jupyter
  ;; kubel
  ;; load-relative
  ;; magit
  ;; marginalia
  ;; multiple-cursors
  ;; nix-mode
  ;; orderless
  ;; paredit
  ;; paredit-everywhere
  ;; projectile
  ;; promise
  ;; pyvenv
  ;; queue
  ;; rainbow-delimiters
  ;; rainbow-mode
  ;; restart-emacs
  ;; reverse-im
  ;; rg
  ;; ripgrep
  ;; slime
  ;; smartparens
  ;; sudo-edit
  ;; ts
  ;; ucs-utils
  ;; undo-tree
  ;; unicode-fonts
  ;; vertico
  ;; virtualenvwrapper
  ;; wallpaper
  ;; wgrep
  ;; whitespace-cleanup-mode

  packages.exwm.exwm-system-view
  packages.expal
  packages.dired+
  packages.grab-and-drag
  packages.vertico-directory
  packages.nix-company
  packages.temporary-mode

  lisp.core.exwm
  lisp.core.dired
  lisp.core.eshell
  lisp.core.scratch

  lisp.org.babel

  lisp.ui.overrides
  lisp.ui.tablet
  lisp.ui.rainbow
  lisp.ui.theme
  lisp.ui.fonts
  lisp.ui.wallpaper
  lisp.ui.window

  lisp.editor.duplicate-line
  lisp.editor.parens
  lisp.editor.multiple-cursors
  lisp.editor.expand-region
  lisp.editor.increment-number
  lisp.editor.undo-tree

  lisp.programming.magit
  lisp.programming.lisp
  lisp.programming.clojure
  lisp.programming.python

  lisp.completion.vertico
  lisp.completion.company

  lisp.os.nixos

  lisp.utils.restart-emacs
  lisp.utils.firestarter

  lisp.core.keys)

(add-to-list 'load-path "~/Stuff/org-glance")
(require 'org-glance)
(define-key global-map (kbd "C-x j") #'org-glance-form-action)
(define-key org-mode-map (kbd "@") #'org-glance:@)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(condition-case nil
    (load-file (f-join user-emacs-directory "init-local.el"))
  (file-missing nil))

(toggle-frame-fullscreen)

;;; init.el ends here
