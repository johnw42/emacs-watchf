(require 'cl)

(defvar watchf-uuid nil)

(defun watchf-gensym (name)
  (assert watchf-uuid)
  (intern (concat name "-" watchf-uuid)))

(defmacro* watchf (to-watch
                   &rest rest
                   &key uuid test
                   &allow-other-keys)
  (declare (indent 1))
  (while (keywordp (car rest))
    (setq rest (cddr rest)))
  (let ((watchf-uuid (or uuid watchf-uuid)))
    ;; (message "%S" `'(watchf ,to-watch ,rest ,uuid ,test))
    `(progn
       (message "initial value of %S: %S" ',to-watch ,to-watch))))

(defmacro* defwatchf (form
                      &key
                      uuid
                      on-global-subscribe
                      on-global-unsubscribe)
  (declare (indent 1))
  (let* ((watchf-uuid uuid)
         (watchf-hook (watchf-gensym "watchf-hook")))
    )
  
  )

(defmacro watchf-add-hook (hook &rest body)
  (declare (indent 1))
  (let* ((func-name (watchf-gensym (symbol-name hook)))
         hook-options)
    (unless (symbolp hook)
      (setq hook-options (cdr hook)
            hook (car hook)))
    `(add-hook ',hook-name
               (defun ,func-name () ,@body)
               ,@hook-options)))

(defmacro watchf-remove-hook (hook)
  (let* ((func-name (watchf-gensym (symbol-name hook))))    
    `(remove-hook ',hook-name ',func-name)))

(defmacro watchf-defined-p (uuid))

(defmacro watchf-subscribed-p (uuid))

(watchf (watchf-defined-p watchable-form)
  :uuid "024efe88-0a8b-4722-8b1d-f3c49c16c4fc")

(watchf (watchf-subscribed-p watchable-form)
  :uuid "024efe88-0a8b-4722-8b1d-f3c49c16c4fc")

(defwatchf major-mode
  :uuid "da16a575-782c-4611-b023-ca488cf7a59a"
  :on-global-subscribe
  (watch-add-hook change-major-mode-hook)
  :on-global-unsubscribe
  nil)

(defwatchf (derived-mode-p &rest modes)
  :uuid "0ec6e4ac-c588-42cf-ba50-699214c9d099")

(defwatchf (buffer-modified-p &optional buffer)
  :uuid "14b3a091-0efa-4014-baa3-aec6ede455fc"
  :on-global-subscribe
  (progn
    ;; after-save-hook
    ;; after-load-hook
    (add-hook 'first-change-hook nil))
  :on-global-unsubscribe
  nil
  )

(watchf major-mode
  :uuid "bb625b8d-2068-49af-9e23-2ac26f336ab3"
  (message "new major mode: %S" major-mode))

(let ((buffer (get-buffer "watchf.el")))
  (watchf (buffer-modified-p buffer)
    :uuid "3f8ed676-298e-469a-b515-826fb002ca32"
    :test 'null
    (with-current-buffer buffer
      (message "Buffer was saved: %s" (buffer-file-name)))))


(fundamental-mode)
(emacs-lisp-mode)

(provide 'watchf)
