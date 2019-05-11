;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")
(
 (org-mode
  (org-babel-tmate-session-prefix . "")
  (org-babel-tmate-default-window-name . "main")
  (org-confirm-babel-evaluate . t)
  (org-use-property-inheritance . t)
  (org-file-dir . (file-name-directory buffer-file-name))
  (eval
   .
   (progn
     ;; (let ((socket-arg (concat ":socket " "FLOOPIE" ))))
     ;; (set (make-local-variable 'tmpdir)
     ;;      (make-temp-file (concat "/dev/shm/" user-buffer "-") t))
     (set (make-local-variable 'ssh-user)
          "pair")
          ;; user-login-name)
     ;; might be nice to set this as a global property in the org file
     (set (make-local-variable 'ssh-host)
          "ii.cncf.ci")
     (set (make-local-variable 'ssh-user-host)
          (concat ssh-user "@" ssh-host))
     (set (make-local-variable 'time-stamp-zone)
          "Pacific/Auckland")
     (set (make-local-variable 'time-stamp-pattern)
          ;; https://www.emacswiki.org/emacs/TimeStamp
          "10/#+UPDATED: needs time-local formatted regexp")
     (set (make-local-variable 'user-buffer)
          (concat user-login-name "." (file-name-base load-file-name)))
     (set (make-local-variable 'socket)
          (concat "/tmp/" user-buffer ".target.iisocket"))
     (set (make-local-variable 'socket-param)
          (concat ":sockets " socket))
     (set (make-local-variable 'item-str)
          "(nth 4 (org-heading-components))")
     (set (make-local-variable 'org-file-properties)
          (list
           (cons 'header-args:tmate
                 (concat
                  " :noweb yes"
                  " :noweb-ref " item-str
                  " :comments org"
                  " :eval no-export"
                  " :results silent "
                  " :session (concat user-login-name \":\" " item-str ")"
                  " :socket " socket
                  " :window " user-login-name
                  " :terminal sakura"
                  " :exports code"
                  ;; If you want each tmate command to run from a particular directory
                  ;; " :prologue (concat \"cd \" ssh-dir \"\n\")"
                  ;; " :prologue (concat "cd " org-file-dir "\n") ))
                  ))
           (cons 'header-args:emacs-lisp
                 (concat
                  " :noweb yes"
                  " :noweb-ref " item-str
                  " :comments org"
                  " :eval no-export"
                  " :results code"
                  " :exports both"
                  ))
           (cons 'header-args:elisp
                 (concat
                  " :noweb yes"
                  " :noweb-ref " item-str
                  " :comments org"
                  " :eval no-export"
                  " :results code"
                  " :exports both"
                  ))
           (cons 'header-args:bash
                 (concat
                  " :noweb yes"
                  " :noweb-ref " item-str
                  " :comments org"
                  " :eval no-export"
                  " :results output code verbatis replace"
                  " :exports both"
                  " :wrap EXAMPLE"
                  ;; This can help catch stderr and other issues
                  ;; " :prologue \"exec 2>&1\n\""
                  ;; " :epilogue \":\n\""
                  ;; " :prologue exec 2>&1\n(\n"
                  ;; " :epilogue )\n:\n"
                  ;; If you want commands executing over tramp
                  ;; " :dir (symbol-value 'tmpdir)"
                  ;; " :dir (concat \"ssh:\" ssh-user \"@\" ssh-host \":~\""
                  ;; " :dir (concat \"ssh:\" ssh-user \"@\" ssh-host \":~\""
                  ;; If you want to feed an application via HEREDOC
                  ;;   :PROPERTIES:
                  ;; " :prologue exec 2>&1\nbq query -n 2000 --nouse_legacy_sql  <<EOF\n"
                  ;; " :epilogue "\nEOF\n:\n"
                  ))
           (cons 'header-args:shell
                 (concat
                  " :noweb yes"
                  " :noweb-ref " item-str
                  " :comments org"
                  " :eval no-export"
                  " :results output code verbatis replace"
                  " :exports both"
                  " :wrap EXAMPLE"
                  ))
           (cons 'header-args:json
                 (concat
                  " :noweb yes"
                  " :comments org"
                  " :noweb-ref " item-str
                  " :exports both"
                  ))
           (cons 'header-args:yaml
                 (concat
                  " :noweb yes"
                  " :comments org"
                  " :noweb-ref " item-str
                  " :exports both"
                  ))
           )
          )
     (set (make-local-variable 'select-enable-clipboard) t)
     (set (make-local-variable 'select-enable-primary) t)
     (set (make-local-variable 'start-tmate-command)
          (concat
           "tmate -S "
           socket
           " new-session -A -s "
           user-login-name
           " -n main "
           "\"tmate wait tmate-ready "
           "&& TMATE_CONNECT=\\$("
           "tmate display -p '#{tmate_ssh} # "
           user-buffer
           ".target # "
           ;; would like this to be shorter
           (concat
            (format-time-string "%Y-%m-%d %T")
            (funcall (lambda ($x) (format "%s:%s" (substring $x 0 3) (substring $x 3 5))) (format-time-string "%z")))
           " # #{tmate_web} ') "
           "; echo \\$TMATE_CONNECT "
           "; (echo \\$TMATE_CONNECT | xclip -i -sel p -f | xclip -i -sel c ) 2>/dev/null "
           "; echo Share the above with your friends and hit enter when done. "
           "; read "
           "; bash --login\""
           )
          )
     ;; at some point we can bring back working on remote hosts
     (set (make-local-variable 'start-tmate-over-ssh-command)
          (concat
           "tmate -S "
           socket
           " new-session -A -s "
           user-login-name
           " -n main "
           "\"tmate wait tmate-ready "
           "\\&\\& TMATE_CONNECT=\\$\\("
           "tmate display -p '#{tmate_ssh} # "
           user-buffer
           ".target # "
           (concat
            (format-time-string "%Y-%m-%d %T")
            (funcall (lambda ($x) (format "%s:%s" (substring $x 0 3) (substring $x 3 5))) (format-time-string "%z")))
           " #{tmate_web} '\\) "
           "; echo \\$TMATE_CONNECT "
           "; \\(echo \\$TMATE_CONNECT \\| xclip -i -sel p -f \\| xclip -i -sel c \\) 2>/dev/null "
           "; echo Share the above with your friends and hit enter when done. "
           "; read "
           "; bash --login\""
           )
          )
     ;; # eval: (set (make-local-variable 'ssh-user-host) (concat ssh-user "@" ssh-host))
     ;; # eval: (set (make-local-variable 'start-tmate-over-ssh-command) (concat "tmate -S " socket " new-session -A -s " user-login-name " -n main \\\"tmate wait tmate-ready \\&\\& tmate display -p \\'#{tmate_ssh}\\' \\| xclip -i -sel p -f \\| xclip -i -sel c \\&\\& bash --login\\\""))
     ;; # eval: (set (make-local-variable 'start-tmate-locally-command) (concat "tmate -S " socket " new-session -A -s " user-login-name " -n main \\\"tmate wait tmate-ready \\&\\& tmate display -p \\'#{tmate_ssh}\\' \\| xclip -i -sel p -f \\| xclip -i -sel c \\&\\& bash --login\\\""))
     ;; # eval: (xclip-mode 1) 
     ;; # eval: (gui-select-text (concat "ssh -tAX " ssh-user-host " -L " socket ":" socket " " start-tmate-over-ssh-command))
     (defun runs-and-exits-zero (program &rest args)
       "Run PROGRAM with ARGS and return the exit code."
       (with-temp-buffer
         (if (= 0 (apply 'call-process program nil (current-buffer) nil args))
             'true
           ))
       )
     (defun xclip-working ()
       "Quick Check to see if X is working."
       (if (getenv "DISPLAY")
           (if (runs-and-exits-zero "xset" "q")
               ;; Using xclip to set an invalid selection is as lightly intrusive
               ;; check I could come up with, and not overwriting anything
               ;; however it seems to hang
               ;; (if (runs-and-exits-zero "xclip" "-selection" "unused")
               ;;     'true)
               'true
             )
         )
       )
     (defun populate-x-clipboard ()
       "Populate the X clipboard with the start-tmate-command"
       (message "Setting X Clipboard to contain the start-tmate command")
       (xclip-mode 1)
       (gui-select-text start-tmate-command)
       (xclip-mode 0)
       (with-current-buffer (get-buffer-create "start-tmate-command")
         (insert-for-yank "The following has been populated to your local X clipboard:\n")
         )
       )
     ;; For testing / setting DISPLAY to something else
     ;; (getenv "DISPLAY")
     ;; (setenv "DISPLAY" ":0")
     ;; As we start on other OSes, we'll need to copy this differently
     (if (xclip-working)
         (populate-x-clipboard)
       (
        (with-current-buffer (get-buffer-create "start-tmate-command")
          (insert-for-yank "You will need to copy this manually:\n\n")
          )
        )
       )
     ;; needs to be global, so it's availabel to the other buffer
     (setq tmate-command start-tmate-command)
     (with-current-buffer (get-buffer-create "start-tmate-command")
       (insert-for-yank
        (concat "\nOpen another terminal on the same host and paste:\n\n" tmate-command)
        ))
     (switch-to-buffer "start-tmate-command")
     (y-or-n-p "Have you Pasted?")
     ;; (gui-select-text (concat "rm -fi " socket "; ssh -tAX " ssh-user "@" ssh-host " -L " socket ":" socket " " start-tmate-over-ssh-command))
     ;; (edebug-trace "TRACING socket:%S" socket)
     ;; (edebug-trace "TRACING org-babel-header-args:tmate %S" org-babel-header-args:emacs-lisp)
     ;; we could try and create a buffer / clear it on the fly
     ;; ssh later? 
     ;; (with-current-buffer (get-buffer-create "start-tmate-command")
     ;;   (insert-for-yank
     ;;    (concat "\nOpen another terminal on the same host and paste:\n\n" tmate-command)
     ;;    ))
     ;; FIXME! How do we find out what our local filname is?
     ;; This was designed for dir-locals... can we reach in?
     ;; (switch-to-buffer (get-buffer buffer-file-name))
     ;; (spacemacs/toggle-maximize-buffer)
     )
   )
  )
 )
;; Add Later
;; https://www.emacswiki.org/emacs/AutomaticFileHeaders #templates / updates etc
;; ^^ based on https://www.emacswiki.org/emacs/download/header2.el
;; ;; https://stackoverflow.com/questions/13228001/org-mode-nested-properties
