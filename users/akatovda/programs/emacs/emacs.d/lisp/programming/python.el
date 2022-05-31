;; Python setup

(my-project-provide emacs-config)

(add-hook 'python-mode-hook #'auto-virtualenvwrapper-activate)
(add-hook 'python-mode-hook #'flycheck-mode)
(add-hook 'python-mode-hook #'flycheck-pycheckers-setup)

(setq-default flycheck-pycheckers-checkers '(pylint mypy3 pep8 flake8 pyflakes bandit))

(add-hook 'python-mode-hook 'python-highlight-breakpoints)
(defun python-highlight-breakpoints()
  (interactive)
  (highlight-lines-matching-regexp "import ipdb")
  (highlight-lines-matching-regexp "import pdb")
  (highlight-lines-matching-regexp "set_trace()")
  (highlight-phrase "TODO")
  (highlight-regexp "FIXME"))

(define-abbrev-table 'python-mode-abbrev-table
    '(("pdb" "import pdb; pdb.set_trace()" nil 0)
      ("ipdb" "import ipdb; ipdb.set_trace()" nil 0)))

;; (add-to-list 'ob-languages '(python . t))
;; (org-babel-do-load-languages 'org-babel-load-languages ob-languages)

(defun my-get-thing-at-point (thing)
  (condition-case nil
      (substring-no-properties (thing-at-point thing))
    (error "")))

(defun my-python-smart-complete ()
  (when (and (string= major-mode "python-mode")
             (looking-at "$")
             (not (python-syntax-comment-or-string-p))
             (eq this-command 'self-insert-command))
    (let* ((line (my-get-thing-at-point 'line))
           (ws (my-get-thing-at-point 'whitespace))
           (words (s-split-words line))
           (init-cmd (car words))
           (last-cmd (car (last words))))
      (when (or
             (and (string= init-cmd "from") (looking-back "\\." 1))
             (looking-back "\\." 1)
             (and (looking-back " " 1) ;; space completions
                  (or                  ;; complete imports
                   (string= last-cmd "import")
                   (string= last-cmd "from")
                   (string= last-cmd "with")

                   (and (string= init-cmd "from") (looking-back ", " 1)))))
        (anaconda-mode-complete)))))

(add-hook 'python-mode-hook #'anaconda-eldoc-mode)
(add-hook 'python-mode-hook #'anaconda-mode)
(add-hook 'python-mode-hook #'(lambda () (setq-local company-backends '(company-anaconda))))
;; (add-hook 'post-command-hook #'my-python-smart-complete)

(defun anaconda-mode-complete-callback (result)
  "Start interactive completion on RESULT receiving."
  (let* ((bounds (bounds-of-thing-at-point 'symbol))
         (start (or (car bounds) (point)))
         (stop (or (cdr bounds) (point)))
         (collection (anaconda-mode-complete-extract-names result))
         (completion-extra-properties '(:annotation-function anaconda-mode-complete-annotation)))
    (delete-region start stop)
    (insert (org-completing-read "Anaconda complete: " collection))))

(cl-defun my-python-paragraph-bounds ()
  (let* ((bounds (save-excursion
                   (while (and (not (bobp))
                               (string-prefix-p " " (thing-at-point 'line t)))
                     (python-nav-beginning-of-block)
                     (when (string-prefix-p " " (thing-at-point 'line t))
                       (forward-line -1)))

                   (beginning-of-line)

                   (let ((end (save-excursion (python-nav-end-of-block) (point))))
                     (while (save-excursion
                              (forward-line -1)
                              (string-prefix-p "@" (thing-at-point 'line t)))
                       (forward-line -1))
                     (cons (point) end))))
         (beg (car bounds))
         (end (cdr bounds)))

    (when (= beg end)
      (let ((bounds (expal:bounds)))
        (setq beg (car bounds)
              end (min (cdr bounds) (point-max)))))

    (cons beg end)))

(cl-defun my-python-kill-comments ()
  (interactive)
  (save-excursion
    (let ((bounds (my-python-paragraph-bounds)))
      (goto-char (1- (cdr bounds)))
      (end-of-line))

    (pcase (org-at-comment-p)
      (_ (while (org-at-comment-p)
           (forward-line -1))
         (forward-line))
      (nil (forward-line)))

    (while (org-at-comment-p)
      (beginning-of-line)
      (kill-line)
      (unless (eobp)
        (kill-line)))

    ;; (when (string-empty-p (s-trim (thing-at-point 'line t)))
    ;;   (kill-line))
    ))

(defvar my-python-interpreters (make-hash-table :test 'equal))

(cl-defun my-python-paragraph-eval ()
  (interactive)
  (let* ((bounds (my-python-paragraph-bounds))
         (beg (car bounds))
         (end (cdr bounds)))

    (pulse-momentary-highlight-region beg end 'region)
    (redisplay)

    (let* ((contents
            (let ((actual (s-trim (buffer-substring-no-properties beg end))))
              (with-temp-buffer
                (insert actual)
                (goto-char (point-min))
                (cond
                  ((s-contains-p " = " (thing-at-point 'line t))
                   (concat
                    "from pprint import pprint"
                    "\n"
                    actual
                    "\n"
                    "pprint("
                    (buffer-substring-no-properties
                     (point-min)
                     (save-excursion
                       (- (search-forward " = ") 3)))
                    ")"))
                  ((s-ends-with-p "?" actual)
                   (concat
                    "from pprint import pprint"
                    "\n"
                    "pprint(dir("
                    (substring-no-properties actual 0 (- (length actual) 1))
                    "))"))
                  ((s-ends-with-p "^^" actual)
                   (concat
                    "from pprint import pprint\n"
                    "pprint("
                    (substring-no-properties actual 0 (- (length actual) 2))
                    ")"))
                  (t actual)))))

           (result (save-window-excursion
                     (let ((process (pcase (gethash (projectile-project-root) my-python-interpreters)
                                      ((or (pred null) (pred (-compose 'not 'process-live-p)))
                                       (puthash (projectile-project-root) (run-python) my-python-interpreters))
                                      (t (gethash (projectile-project-root) my-python-interpreters)))))
                       (python-shell-send-string-no-output contents process)))))

      (save-excursion
        (goto-char (1- end))
        (end-of-line)

        (if (eobp)
            (newline)
          (my-python-kill-comments)
          (forward-char))

        (pp result)

        ;; (let ((comment "# ")
        ;;       (none "None")
        ;;       (result-beg (point))
        ;;       result-end)
        ;;   (if (or (string-empty-p result)
        ;;           (string= result none))
        ;;       (hlt-highlight-region beg end 'expal-block-success-face)
        ;;     (insert result "\n")
        ;;     (setq result-end (min (point) (point-max)))
        ;;     (cl-loop
        ;;        initially (goto-char result-beg)
        ;;        while (< (point) result-end)
        ;;        do (progn
        ;;             (beginning-of-line)
        ;;             (insert comment)
        ;;             (forward-line)
        ;;             (setq result-end (+ result-end (length comment))))
        ;;        finally
        ;;          (unless (string-empty-p (s-trim (thing-at-point 'line t)))
        ;;            (newline)))))
        ))))

(require 'python)
(define-key python-mode-map (kbd "C-c C-c") 'my-python-paragraph-eval)
(define-key python-mode-map (kbd "C-c C-k") 'my-python-kill-comments)
