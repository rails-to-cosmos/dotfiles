(my-project-provide emacs-config)

(defvar ob-languages '())

(cl-defun ob-add-language (language)
  (add-to-list 'ob-languages (cons language t))
  (condition-case err
      (org-babel-do-load-languages 'org-babel-load-languages ob-languages)
    (error
     (setq ob-languages (remove (cons language t) ob-languages))
     (user-error "Unable to register language: %s" err))))
