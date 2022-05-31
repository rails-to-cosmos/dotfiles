;;; init.el --- my emacs configuration
;;; Commentary:
;;; Code:

(require 'f)
(require 'custom)

(require 'my-project (f-join user-emacs-directory "lisp" "my-project.el"))

(defvar emacs-config
  (my-project :name "my-emacs-config"
              :root (file-name-directory (__FILE__))))

(unicode-fonts-setup)

(my-project-require emacs-config
  packages.expal
  packages.dired+
  packages.grab-and-drag
  packages.vertico-directory
  packages.nix-company

  lisp.core.dired
  lisp.core.eshell
  ;; lisp.core.locale
  lisp.core.scratch

  lisp.org.babel

  lisp.ui.overrides
  lisp.ui.tablet
  lisp.ui.rainbow
  lisp.ui.theme
  lisp.ui.fonts

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

;;; init.el ends here
