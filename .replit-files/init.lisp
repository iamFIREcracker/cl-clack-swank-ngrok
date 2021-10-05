#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (if (probe-file quicklisp-init)
      (load quicklisp-init)
      (progn
        (load (merge-pathnames "quicklisp.lisp" *load-truename*))
        (funcall (find-symbol "INSTALL" (find-package "QUICKLISP-QUICKSTART"))))))


;;; Nicer prompt
(defvar *last-package* nil)
(defvar *cached-prompt* nil)
(defun package-prompt (stream)
  (when (not (eq *last-package* *package*))
    (setf *cached-prompt*
          (format nil "~%[SBCL] ~A "
                  (or (first (package-nicknames *package*))
                      (package-name *package*))))
    (setf *last-package* *package*))
  (terpri)
  (princ *cached-prompt* stream))

(setf sb-int:*repl-prompt-fun* #'package-prompt)


;;; Scratch Marker
(defun sharp-semicolon-reader (stream sub-char numarg)
  (declare (ignore sub-char numarg))
  (loop :while (read-line stream nil nil))
  (values))
(set-dispatch-macro-character #\# #\; #'sharp-semicolon-reader)
