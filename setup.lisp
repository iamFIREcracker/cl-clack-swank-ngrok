;; Make it possible to laod systems nested inside vendor/
(pushnew '(merge-pathnames (parse-namestring "vendor/ngrok/")
           *default-pathname-defaults*)
         asdf:*central-registry*)
;; Make it possible to QL:QUICKLOAD systems defined in this repo
(pushnew '*default-pathname-defaults* asdf:*central-registry*)
