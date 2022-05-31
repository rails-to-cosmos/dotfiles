(my-project-provide emacs-config)

(defun increment-number-at-point ()
  (interactive)
  (save-excursion
    (skip-chars-backward "\-0-9")
    (or (looking-at "\-?[0-9]+")
	(error "No number at point"))
    (replace-match (number-to-string (1+ (string-to-number (match-string 0)))))))

(defun decrement-number-at-point ()
  (interactive)
  (skip-chars-backward "\-0-9")
  (or (looking-at "\-?[0-9]+")
      (error "No number at point"))
  (replace-match (number-to-string (1- (string-to-number (match-string 0))))))

(global-set-key (kbd "C-+") #'increment-number-at-point)
(global-set-key (kbd "C--") #'decrement-number-at-point)
