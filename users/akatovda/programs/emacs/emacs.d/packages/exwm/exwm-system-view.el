;; -*- lexical-binding: t; -*-

(my-project-provide emacs-config)

(require 'navigel)
(require 'dash)
(require 'pcase)
(require 'ctable)
(require 's)

(defun ctbl::sort-current ()
  (interactive)
  (let ((cp (ctbl:cp-get-component))
        (cell-id (ctbl:cursor-to-nearest-cell)))
    (when (and cp cell-id)
      (ctbl:cmodel-sort-action cp (cdr (ctbl:cp-get-selected cp)))
      (ctbl:cp-set-selected-cell cp cell-id))))

(defun exwm-system-report ()
  (interactive)
  (let* ((buffer (get-buffer-create "*exwm-system-report*"))
         (process (start-process "nmcli" buffer "nmcli" "device" "wifi"))
         (splitter "[[:space:]]\\{2,\\}")
         (boolsort (lambda (lhs rhs)
                     (cond
                       ((not (or lhs rhs)) 0)
                       (lhs -1)
                       (rhs 1)
                       (t 0))))
         (sigsort (lambda (lhs rhs)
                    (ctbl:sort-number-lessp
                     (s-count-matches "_" lhs)
                     (s-count-matches "_" rhs))))
         (schema (list (make-ctbl:cmodel :title ""
                                         :align 'right
                                         :min-width 1
                                         :sorter boolsort)
                       (make-ctbl:cmodel :title "Name" :align 'left)
                       (make-ctbl:cmodel :title "Signal" :align 'left :sorter sigsort)))
         (nmcli-map (ctbl:define-keymap
                     '(("k" . ctbl:navi-move-up)
                       ("j" . ctbl:navi-move-down)
                       ("h" . ctbl:navi-move-left)
                       ("l" . ctbl:navi-move-right)

                       ("p" . ctbl:navi-move-up)
                       ("n" . ctbl:navi-move-down)
                       ("b" . ctbl:navi-move-left)
                       ("f" . ctbl:navi-move-right)

                       ("c" . ctbl:navi-jump-to-column)

                       ("e" . ctbl:navi-move-right-most)
                       ("a" . ctbl:navi-move-left-most)

                       ("g" . ctbl:action-update-buffer)

                       ("?" . ctbl:describe-bindings)

                       ([mouse-1] . ctbl:navi-on-click)
                       ("C-m" . ctbl:navi-on-click)
                       ("RET" . ctbl:navi-on-click)

                       ("^" . ctbl::sort-current))))
         (data nil))

    (set-process-filter process
                        (lambda (process output)
                          (cl-loop
                             with split-out = (s-split "\n" output)
                             with contents = (cdr split-out)
                             for line in contents
                             collect (-let [(in-use bssid ssid mode channel rate signal bars security)
                                            (s-split splitter line)]
                                       (when ssid
                                         (cl-pushnew (list (string= in-use "*") ssid bars) data))))))

    (set-process-sentinel process
                          (lambda (process status)
                            (when (string= (s-trim status) "finished")
                              (with-current-buffer buffer

                                (special-mode)

                                (let ((inhibit-read-only t))
                                  (delete-region (point-min) (point-max))
                                  (insert "Wireless networks\n")
                                  (let* ((model (make-ctbl:model
                                                 :column-model schema
                                                 :data data
                                                 :sort-state '(3)))
                                         (component (ctbl:create-table-component-region
                                                     :model model
                                                     :keymap nmcli-map)))

                                    (ctbl:cp-add-click-hook
                                     component
                                     (lambda ()
                                       (ctbl:cmodel-sort-action component (cdr (ctbl:cp-get-selected component)))
                                       (message "CTable : Click Hook [%S] [%S] [%S]"
                                                (ctbl:cp-get-selected component)
                                                (ctbl:cp-get-selected-data-row component)
                                                (ctbl:cp-get-selected-data-cell component))))
                                    )))
                              (switch-to-buffer-other-window buffer))))))
