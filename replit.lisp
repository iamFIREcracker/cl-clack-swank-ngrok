(load ".replit-files/init.lisp")
(load "setup.lisp")

(ql:quickload "web")
(web:start :web-interface "0.0.0.0")
