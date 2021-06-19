(uiop:define-package #:web
  (:export
   #:start
   #:stop))
(in-package #:web)


(defun main (&key dont-ngrok)
  (clack)
  (swank)
  (unless dont-ngrok
    (ngrok)))


(defvar *handler* nil)

(defun clack () (setf *handler* (clack:clackup #'srv :address "0.0.0.0" :port 5000)))

(defun srv (env) (app env))

(defun app (env)
  (declare (ignore env))
  '(200 (:content-type "text/plain") ("Hello, Clack!")))


(defvar *slime-secret* (uiop:getenv "SLIME_SECRET"))
(defparameter *swank-port* 4006)

(defun swank ()
  (write-slime-secret)
  (swank:create-server :port *swank-port* :dont-close t))

(defun write-slime-secret ()
  (with-open-file (stream "~/.slime-secret" :direction :output :if-exists :supersede)
    (write-string *slime-secret* stream)))


(defvar *ngrok-auth-token* (uiop:getenv "NGROK_AUTH_TOKEN"))

(defun ngrok () (ngrok:start *swank-port* :auth-token *ngrok-auth-token*))


(defun getenv-or-readline (name)
  "Gets the value of the environment variable, or asks the user to provide
   a value for it."
  (or (uiop:getenv name)
      (progn
        (format *query-io* "~a=" name)
        (force-output *query-io*)
        (read-line *query-io*))))

(defun start (&key dont-ngrok)
  (let ((*slime-secret* (getenv-or-readline "SLIME_SECRET"))
        (*ngrok-auth-token* (if dont-ngrok
                                *ngrok-auth-token*
                                (getenv-or-readline "NGROK_AUTH_TOKEN"))))
    (main :dont-ngrok dont-ngrok)))

(defun stop()
  (ngrok:stop)
  (swank:stop-server *swank-port*)
  (when *handler*
    (prog1 (clack:stop *handler*)
      (setf *handler* nil))))
