# clack-swank-ngrok
Hello world Clack application, with Swank and Ngrok running in the background
for remote hacking

## Overview

- Clack Web application running on `0.0.0.0:5000`
- Swank server running on `localhost:4006`
- Ngrok tunnel to expose `localhost:4006` (i.e. the Swank server)

## Instructions

Clone the repository:

    $ cd ~/Workspace
    $ git clone https://github.com/iamFIREcracker/cl-clack-swank-ngrok.git

Setup ADFS so it can load any system defined in this repository:

    > (load "setup.lisp")

Quickload the main system:

    > (ql:quickload "web")
    To load "web":
      Load 1 ASDF system:
        web
    ; Loading "web"
    ..........
    ("web")

Call WEB:START:

    > (web:start)
    Hunchentoot server is started.
    Listening on 0.0.0.0:5000.
    ;; Swank started at port: 4006.
     <INFO> [10:13:43] ngrok setup.lisp (install-ngrok) -
      Ngrok already installed, changing authtoken
     <INFO> [10:13:44] ngrok setup.lisp (start) - Starting Ngrok on TCP port 4006
     <INFO> [10:13:44] ngrok setup.lisp (start) -
      Tunnnel established! Connect to the tcp://6.tcp.eu.ngrok.io:12321
    "tcp://6.tcp.eu.ngrok.io:12321"

Note: the application will
[_secure_](https://github.com/slime/slime/issues/286) the Swank server by
writing a user provided secret into ~/.slime-secret (watch out, it _will_
overwrite whichever existing secret was previously stored there!); by default,
the secret is read from the `SLIME_SECRET` environment variable, but if such
variable were missing, the application will prompt the user to provide a value
at run time.  Similarly, the value of the `NGROK_AUTH_TOKEN` environment
variable is used to tell Ngrok the account the newly created tunnel should be
associated with, and again, should that variable not exist, the user will be
asked to provide a value when WEB:START is called.

    > (web:start)
    SLIME_SECRET=my-secret-secret
    NGROK_AUTH_TOKEN=auth-for-the-win
    Hunchentoot server is started.
    ...

Note: in case you did not want / need Ngrok to run (say because you have SSH
access to the server the application is running on, and you prefer to connect
to the Swank server with an [SSH
tunnel](https://riptutorial.com/common-lisp/example/25252/setting-up-a-swank-server-over-a-ssh-tunnel-)
instead), then all you have to do is pass `:dont-ngrok t` to WEB:START:

    > (web:start :dont-ngrok t)
    Hunchentoot server is started.
    Listening on 0.0.0.0:5000.
    ;; Swank started at port: 4006.

Test the Web server:

    $ curl https://localhost:5000
    Hello, Clack!

Open Vim/Emacs, connect to the Swank server (i.e. host: `6.tcp.eu.ngrok.io`,
port: `12321`), and change the Web handler to return something different:

    > (defun app (env)
        (declare (ignore env))
        '(200 (:content-type "text/plain") ("Hello, Matteo!")))
    APP

Hit the Web server again, and this time it should return a different message:

    $ curl https://localhost:5000
    Hello, Matteo!

To stop the application (and the Swank server, and the Ngrok tunnel) simply
call the STOP function:

    > (web:stop)

## See also

- [ASDF](https://common-lisp.net/project/asdf/): Another System Definition
  Facility
- [Clack](https://github.com/fukamachi/clack): Web Application Environment for
  Common Lisp
- [SLIME](https://github.com/slime/slime): the Superior Lisp Interaction Mode
  for Emacs
- [ngrok](https://github.com/40ants/ngrok): (WIP) Common Lisp wrapper for
  installing and running Ngrok.
