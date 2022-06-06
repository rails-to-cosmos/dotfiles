;; -*- lexical-binding: t; -*-

(my-project-provide emacs-config)

(require 'navigel)
(require 'dash)
(require 'pcase)
(require 'ctable)
(require 's)

(require 'simple)

(defvar exwm-system-report-mode-map
  (let ((map (make-sparse-keymap)))
    (suppress-keymap map)

    (define-key map "n" 'forward-line)
    (define-key map "p" 'previous-line)
    (define-key map "g" 'exwm-system-report)

    map))

(define-derived-mode exwm-system-report-mode special-mode "exwm system report"
                     "Special mode extended to work with ctbl.")

(defun ctbl::sort-current ()
  (interactive)
  (let ((cp (ctbl:cp-get-component))
        (cell-id (ctbl:cursor-to-nearest-cell)))
    (when (and cp cell-id)
      (ctbl:cmodel-sort-action cp (cdr (ctbl:cp-get-selected cp)))

      (ctbl:cp-set-selected-cell cp cell-id))))

;; (defun ctbl::filter-current ()
;;   (interactive)
;;   (let ((cp (ctbl:cp-get-component))
;;         (cell-id (ctbl:cursor-to-nearest-cell)))
;;     (when (and cp cell-id)
;;       (ctbl:cmodel-sort-action cp (cdr (ctbl:cp-get-selected cp)))
;;       (ctbl:cp-set-selected-cell cp cell-id))))

(defun ctbl::navi-move-backward ()
  (interactive)
  (let* ((cp (ctbl:cp-get-component))
         (cell-id (ctbl:cursor-to-nearest-cell))
         (row-id (car cell-id)))
    (cl-flet ((cursor-moved-p () (not (eql cell-id (ctbl:cursor-to-nearest-cell)))))
      (ctbl:navi-move-left)
      (unless (cursor-moved-p)
        (ctbl:navi-move-up)
        (if (cursor-moved-p)
            (ctbl:navi-move-right-most)
          (forward-line -4))))))

(defun ctbl::navi-move-forward ()
  (interactive)
  (when-let (cp (condition-case nil
                    (ctbl:cp-get-component)
                  (error nil)))
    (let* ((cell-id (ctbl:cursor-to-nearest-cell))
           (row-id (car cell-id)))
      (cl-flet ((cursor-moved-p () (not (eql cell-id (ctbl:cursor-to-nearest-cell)))))
        (ctbl:navi-move-right)
        (unless (cursor-moved-p)
          (ctbl:navi-move-down)
          (if (cursor-moved-p)
              (ctbl:navi-move-left-most)
            (forward-line 2)))))))

(defun ctbl::navi-move-down ()
  (interactive)
  (when-let (cp (condition-case nil
                    (ctbl:cp-get-component)
                  (error nil)))
    (let* ((cell-id (ctbl:cursor-to-nearest-cell))
           (row-id (car cell-id)))
      (cl-flet ((cursor-moved-p () (not (eql cell-id (ctbl:cursor-to-nearest-cell)))))
        (ctbl:navi-move-down)
        (unless (cursor-moved-p)
          (forward-line 2))))))

(defun ctbl::navi-move-up ()
  (interactive)
  (when-let (cp (condition-case nil
                    (ctbl:cp-get-component)
                  (error nil)))
    (let* ((cell-id (ctbl:cursor-to-nearest-cell))
           (row-id (car cell-id)))
      (cl-flet ((cursor-moved-p () (not (eql cell-id (ctbl:cursor-to-nearest-cell)))))
        (ctbl:navi-move-up)
        (unless (cursor-moved-p)
          (forward-line -4))))))

(defun boolsort (lhs rhs)
  (cond
    ((not (or lhs rhs)) 0)
    (lhs -1)
    (rhs 1)
    (t 0)))

(defun sigsort (lhs rhs)
  (ctbl:sort-number-lessp
   (s-count-matches "_" lhs)
   (s-count-matches "_" rhs)))

(defvar exwm-system-report-nm-schema
  (list (make-ctbl:cmodel :title ""
                          :align 'right
                          :min-width 1
                          :sorter #'boolsort)
        (make-ctbl:cmodel :title "Name"
                          :align 'left)
        (make-ctbl:cmodel :title "Signal"
                          :align 'left
                          :sorter #'sigsort)
        (make-ctbl:cmodel :title "Channel"
                          :align 'left)
        (make-ctbl:cmodel :title "Rate"
                          :align 'left)
        (make-ctbl:cmodel :title "Security"
                          :align 'left)))

(defvar exwm-system-report-nm-map
  (ctbl:define-keymap
   '(("k" . ctbl::navi-move-up)
     ("j" . ctbl::navi-move-down)
     ("h" . ctbl:navi-move-left)
     ("l" . ctbl:navi-move-right)

     ("p" . ctbl::navi-move-up)
     ("n" . ctbl::navi-move-down)
     ("b" . ctbl:navi-move-left)
     ("f" . ctbl:navi-move-right)

     ("c" . ctbl:navi-jump-to-column)

     ("e" . ctbl:navi-move-right-most)
     ("a" . ctbl:navi-move-left-most)

     ("g" . exwm-system-report)

     ("?" . ctbl:describe-bindings)

     ([mouse-1] . ctbl:navi-on-click)
     ("C-m" . ctbl:navi-on-click)
     ("RET" . ctbl:navi-on-click)
     ("TAB" . ctbl::navi-move-forward)
     ("<backtab>" . ctbl::navi-move-backward)

     ("^" . ctbl::sort-current))))

(defun exwm-system-report ()
  (interactive)
  (let* ((buffer (get-buffer-create "*exwm-system-report*"))
         (process (start-process "nmcli" buffer "nmcli" "-t" "device" "wifi"))
         (splitter "[^\\]:")
         (schema exwm-system-report-nm-schema)
         (data nil))
    (set-process-filter process
                        (lambda (process output)
                          (cl-loop
                             for line in (s-split "\n" output)
                             for rownum from 0
                             do (let* ((separator ":")
                                       (escape-symbol "\\")
                                       (parted (let ((group 0)) (--partition-by (if (s-ends-with? escape-symbol it)
                                                                                    (1+ group)
                                                                                  (incf group))
                                                                                (s-split separator line))))
                                       (pretty (cl-loop for chunk in parted
                                                  if (= 1 (length chunk))
                                                  collect (car chunk)
                                                  else
                                                  collect (s-replace escape-symbol "" (s-join separator chunk)))))
                                  (-let [(in-use bssid ssid mode channel rate signal bars security) pretty]
                                    (when ssid
                                      (cl-pushnew (list (string= in-use "*") ssid bars channel rate security) data)))))))

    (set-process-sentinel process
                          (lambda (process status)
                            (when (string= (s-trim status) "finished")
                              (with-current-buffer buffer

                                (exwm-system-report-mode)

                                (let ((inhibit-read-only t))
                                  (delete-region (point-min) (point-max))
                                  (insert "Wireless networks\n")
                                  (let* ((model (make-ctbl:model
                                                 :column-model schema
                                                 :data data
                                                 :sort-state '(3)))
                                         (component (ctbl:create-table-component-region
                                                     :model model
                                                     :keymap exwm-system-report-nm-map)))

                                    (ctbl:cp-add-click-hook
                                     component
                                     (lambda ()
                                       (message "CTable : Click Hook [%S] [%S] [%S]"
                                                (ctbl:cp-get-selected component)
                                                (ctbl:cp-get-selected-data-row component)
                                                (ctbl:cp-get-selected-data-cell component)))))))
                              (unless (eql (current-buffer) buffer)
                                (switch-to-buffer-other-window buffer)))))))
