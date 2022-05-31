(my-project-provide emacs-config)

(require 'consult)
(require 'vertico)
(require 'vertico-directory)
(require 'orderless)
(require 'marginalia)

(vertico-mode)
(recentf-mode)
(marginalia-mode)

;; Persist history over Emacs restarts. Vertico sorts by history position.
(require 'savehist)
(savehist-mode)

(define-key vertico-map (kbd "RET") #'vertico-directory-enter)
(define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char)
(define-key vertico-map (kbd "M-DEL") #'vertico-directory-delete-word)
;; (rfn-eshadow-update-overlay . vertico-directory-tidy)

(define-key global-map (kbd "C-x b") #'consult-buffer)
(define-key global-map (kbd "M-g M-g") #'consult-goto-line)
(define-key global-map (kbd "C-x SPC") #'consult-mark)
(define-key global-map (kbd "C-c C-r") #'(lambda () (interactive) (consult-ripgrep default-directory (thing-at-point 'symbol))))

;; Use the `orderless' completion style. Additionally enable
;; `partial-completion' for file path expansion. `partial-completion' is
;; important for wildcard support. Multiple files can be opened at once
;; with `find-file' if you enter a wildcard. You may also give the
;; `initials' completion style a try.
(setq completion-styles '(orderless) ;; basic substring partial-completion flex
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))

;; Enable richer annotations using the Marginalia package

;; (use-package corfu
;;     ;; :bind
;;     ;; Configure SPC for separator insertion
;;     ;; (:map corfu-map ("SPC" . corfu-insert-separator))
;;     ;; Optional customizations
;;     :custom
;;   (corfu-cycle t)                   ;; Enable cycling for `corfu-next/previous'
;;   (corfu-auto t)                 ;; Enable auto completion
;;   (corfu-auto-delay 0.1)
;;   ;; (corfu-separator ?-)          ;; Orderless field separator
;;   (corfu-quit-at-boundary nil)   ;; Never quit at completion boundary
;;   (corfu-quit-no-match 'separator)      ;; Never quit, even if there is no match
;;   ;; (corfu-preview-current nil)    ;; Disable current candidate preview
;;   (corfu-preselect-first t)    ;; Disable candidate preselection
;;   ;; (corfu-on-exact-match 'insert)     ;; Configure handling of exact matches
;;   ;; (corfu-echo-documentation nil) ;; Disable documentation in the echo area
;;   ;; (corfu-scroll-margin 5)        ;; Use scroll margin

;;   ;; You may want to enable Corfu only for certain modes.
;;   ;; :hook ((prog-mode . corfu-mode))

;;   ;; Recommended: Enable Corfu globally.
;;   ;; This is recommended since dabbrev can be used globally (M-/).
;;   :init
;;   (corfu-global-mode)
;;   )

;; Add extensions
;; (use-package cape
;;     :init
;;   ;; Add `completion-at-point-functions', used by `completion-at-point'.
;;   ;; (add-to-list 'completion-at-point-functions #'cape-file)
;;   ;; (add-to-list 'completion-at-point-functions #'cape-tex)
;;   ;; (add-to-list 'completion-at-point-functions #'cape-dabbrev)
;;   (add-to-list 'completion-at-point-functions #'cape-keyword)
;;   ;; (add-to-list 'completion-at-point-functions #'cape-anaconda)
;;   ;; (add-to-list 'completion-at-point-functions #'cape-sgml)
;;   ;; (add-to-list 'completion-at-point-functions #'cape-rfc1345)
;;   ;; (add-to-list 'completion-at-point-functions #'cape-abbrev)
;;   ;; (add-to-list 'completion-at-point-functions #'cape-ispell)
;;   ;; (add-to-list 'completion-at-point-functions #'cape-dict)
;;   ;; (add-to-list 'completion-at-point-functions #'cape-symbol)
;;   ;; (add-to-list 'completion-at-point-functions #'cape-line)
;;   )

;; (defun my/corfu-commit-predicate ()
;;   "Auto-commit candidates if:
;; 1. A '.' is typed, except after a SPACE.
;; 2. A selection was made, aside from entering SPACE.
;; 3. Just one candidate exists, and we continue to non-symbol info.
;; 4. The 1st match is exact."
;;   (cond
;;     ((seq-contains-p (this-command-keys-vector) ?.)
;;      (or (string-empty-p (car corfu--input))
;; 	 (not (string= (substring (car corfu--input) -1) " "))))

;;     ((/= corfu--index corfu--preselect) ; a selection was made
;;      (not (seq-contains-p (this-command-keys-vector) ? )))

;;     ((eq corfu--total 1) ;just one candidate
;;      (seq-intersection (this-command-keys-vector) [?: ?, ?\) ?\] ?\( ? ]))

;;     ((and corfu--input ; exact 1st match
;; 	  (string-equal (substring (car corfu--input) corfu--base)
;; 			(car corfu--candidates)))
;;      (seq-intersection (this-command-keys-vector) [?: ?. ?, ?\) ?\] ?\" ?' ? ]))))

;; (setq corfu-commit-predicate #'my/corfu-commit-predicate)
