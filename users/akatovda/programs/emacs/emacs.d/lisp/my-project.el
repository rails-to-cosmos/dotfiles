(require 'eieio)
(require 'f)
(require 's)
(require 'files)
(require 'load-relative)

(defclass my-project ()
  ((name :initarg :name :type string :reader my-project-name)
   (root :initarg :root :type string :reader my-project-root)))

(cl-defmacro my-project-module-filename (project module)
  `(let* ((m (format "%s" (quote ,module)))
          (path (concat (s-replace "." "/" m) ".el")))
     (f-join (my-project-root ,project) path)))

(cl-defmacro my-project-require (project &rest modules)
  (declare (indent 1) (debug t))
  (cl-loop
     for module in modules
     collect
       `(let ((module-package (quote ,module))
              (module-filename (f-join (my-project-root ,project)
                                       (concat (s-replace "." "/" (symbol-name (quote ,module))) ".el"))))
          (condition-case nil
              (load-file module-filename)
            (file-missing
             (message "File %s is missing, trying to use package %s" module-filename module-package)
             (use-package ,module :no-require t))))
     into forms
     finally (return (append `(progn) forms))))

(cl-defmacro my-project-provide (project)
  `(provide (intern (file-name-sans-extension
                     (s-replace "/" "." (file-relative-name (__FILE__) (my-project-root ,project)))))))

(provide-me)
