(uiop:define-package #:web
  (:export
   #:start))
(in-package #:web)


(defun start ()
  (clack)
  (swank)
  (ngrok))


(defun clack () (clack:clackup #'srv :address "0.0.0.0"))

(defun srv (env) (app env))

(defun app (env)
  (declare (ignore env))
  '(200 (:content-type "text/plain") ("Hello, Clack!")))


(defun getenv-or-readline (name)
  "Gets the value of the environment variable, or asks the user to provide
   a value for it."
  (or (uiop:getenv name)
      (progn
        (format *query-io* "~a=" name)
        (force-output *query-io*)
        (read-line *query-io*))))


(defvar *slime-secret* (getenv-or-readline "SLIME_SECRET"))
(defvar *swank-port* (find-port:find-port))

(defun swank ()
  (write-slime-secret)
  (swank:create-server :interface "localhost" :port *swank-port* :dont-close t))

(defun write-slime-secret ()
  (with-open-file (stream "~/.slime-secret" :direction :output :if-exists :supersede)
    (write-string *slime-secret* stream)))


(defvar *ngrok-auth-token* (getenv-or-readline "NGROK_AUTH_TOKEN"))

(defun ngrok () (ngrok:start *swank-port* :auth-token *ngrok-auth-token*))
