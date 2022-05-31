(require 'load-relative)

;; (use-package smex)

;; (use-package counsel
;;   :bind (("M-x" . counsel-M-x)
;;          ("C-x C-f" . counsel-find-file)
;;          ("C-h a" . counsel-describe-face)
;;          ("C-h f" . counsel-describe-function)
;;          ("C-h v" . counsel-describe-variable)
;;          ("C-h l" . counsel-find-library)
;;          ("C-h i" . counsel-info-lookup-symbol)
;;          ("C-h u" . counsel-unicode-char)
;;          ("C-c g" . counsel-git)
;;          ("C-c j" . counsel-git-grep)
;;          ("C-c k" . counsel-ag)
;;          ("C-x l" . counsel-locate)
;;          ("C-x b" . ido-switch-buffer)
;;          :map read-expression-map
;;          ("C-r" . counsel-minibuffer-history))
;;   :config (setq-default counsel-find-file-ignore-regexp "^\\.[^.]\\|\\.pyc$\\|\\.bin|$"))

;; (use-package ivy
;;     :bind (:map ivy-minibuffer-map
;;                 ("RET" . ivy-alt-done)
;;                 ("C-j" . ivy-immediate-done))
;;     :init (progn
;; 	    (setq ivy-re-builders-alist '((nil . ivy--regex-fuzzy)
;;                                           (t . ivy--regex-plus))
;;                   ivy-initial-inputs-alist nil
;;                   ivy-use-virtual-buffers t
;;                   enable-recursive-minibuffers t
;;                   ivy-extra-directories '())
;;             (ivy-mode)))

;; (use-package ivy-posframe)

;; (use-package ivy-yasnippet
;;     :bind (("C-x i" . #'ivy-yasnippet)))

;; (setq projectile-completion-system 'ivy)

(provide-me)
