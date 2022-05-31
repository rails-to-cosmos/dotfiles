(require 'load-relative)

(defun yas-show-expand-keys ()
  "Put overlay on text which is an expandable snippet key.
This function is intended to be added to `post-command-hook'."
  (let ((keys-at-point (and yas-minor-mode (yas--templates-for-key-at-point)))
        (have-overlay (overlayp (buffer-local-value 'yas--expandable-keys-overlay (current-buffer)))))
    (if keys-at-point
        (let ((beg (nth 1 keys-at-point))
              (end (nth 2 keys-at-point)))
          (if have-overlay
              (move-overlay yas--expandable-keys-overlay beg end)
            (setq-local yas--expandable-keys-overlay
                        (make-overlay beg end)))
          (overlay-put yas--expandable-keys-overlay 'face '(:box t)))
      (when have-overlay
        (delete-overlay yas--expandable-keys-overlay)))))

(use-package yasnippet
    :hook ((post-command . yas-show-expand-keys))
    :config (progn
              (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
              (yas-global-mode)
              (defvar-local yas--expandable-keys-overlay nil)))

(provide-me)
