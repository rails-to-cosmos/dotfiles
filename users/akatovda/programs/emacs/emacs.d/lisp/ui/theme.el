(my-project-provide emacs-config)

(require 'danneskjold-theme)
(enable-theme 'danneskjold)

;; (require 'danneskjold-light-theme)
;; (enable-theme 'danneskjold-light)

(eval-after-load 'org-faces
  '(defcustom org-todo-keyword-faces nil
    "Faces for specific TODO keywords.
This is a list of cons cells, with TODO keywords in the car and
faces in the cdr.  The face can be a symbol, a color, or a
property list of attributes, like (:foreground \"blue\" :weight
bold :underline t)."
    :group 'org-faces
    :group 'org-todo
    :type '(repeat
            (cons
	     (string :tag "Keyword")
	     (choice color (sexp :tag "Face"))))))

(eval-after-load 'org
  '(progn
    (defun org-get-todo-face-from-color (color)
      "Returns a specification for a face that inherits from org-todo
 face and has the given color as foreground. Returns nil if
 color is nil."
      (when color
        `(:inherit org-warning :foreground ,color)))

    (defun org-get-todo-face (kwd)
      "Get the right face for a TODO keyword KWD.
If KWD is a number, get the corresponding match group."
      (if (numberp kwd) (setq kwd (match-string kwd)))
      (or (let ((face (cdr (assoc kwd org-todo-keyword-faces))))
            (if (stringp face)
                (org-get-todo-face-from-color face)
              face))
          (and (member kwd org-done-keywords) 'org-done)
          'org-todo))

    (setq org-todo-keyword-faces
     '(("REVIEW" . (:foreground "#292"))
       ("CANCELLED" . (:foreground "#7B9ED2"))
       ("STARTED" . (:foreground "#749AF7"))
       ("PENDING" . (:foreground "#e67e22")) ;FFDB45
       ("DELEGATED" . (:foreground "DarkCyan"
		       :slant italic
		       ;; :box (:line-width 3 :color "#FFDB45")
		       ))
       ("CODE_REVIEW" . (:foreground "#8B7FD7"))))))

;; (require 'color)
;; (set-face-attribute 'org-block nil :background
;;                     (color-darken-name
;;                      (face-attribute 'default :background) 3))

;; (setq org-src-block-faces '(("emacs-lisp" (:background "#EEE2FF"))
;;                             ("python" (:background "#E5FFB8"))))

;; )
