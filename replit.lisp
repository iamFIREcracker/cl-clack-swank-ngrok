(load ".replit-files/init.lisp")

;; Make it possible to laod systems nested inside vendor/
(pushnew '(merge-pathnames (parse-namestring "vendor/ngrok/")
           *default-pathname-defaults*)
         asdf:*central-registry*)

(ql:quickload "web")
(web:start)
