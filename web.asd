(asdf:defsystem #:web
  :description "Hello world Clack application, with a Swank server running in the background for remote hacking"

  :author "Matteo Landi <matteo@matteolandi.net>"
  :license  "MIT"

  :version "0.0.1"

  :depends-on (
                 #:clack
                 #:ngrok
                 #:swank
                 #:uiop
              )

  :components ((:file "main")))
