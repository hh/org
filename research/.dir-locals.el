;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((org-mode
 (org-babel-tmate-session-prefix . "")
 (org-babel-tmate-default-window-name . "main")
 (org-confirm-babel-evaluate . t)
 (org-use-property-inheritance . t)
 (org-file-dir . (file-name-directory buffer-file-name))
 (eval . (set (make-local-variable 'user-buffer)
              (concat user-login-name "." (file-name-base load-file-name))))
 (eval . (set (make-local-variable 'tmpdir)
              (make-temp-file (concat "/dev/shm/" user-buffer "-") t)))
 (eval . (set (make-local-variable 'socket)
              (concat "/tmp/" user-buffer ".iisocket")))
 ;; (:socket . socket)
 ;; (eval . (set (make-local-variable 'select-enable-clipboard) t))
 ;; (eval . (set (make-local-variable 'select-enable-primary) t))
 (eval . (set (make-local-variable 'start-tmate-command)
              (concat
               "tmate -S "
               socket
               " new-session -A -s "
               user-login-name
               " -n main \"tmate wait tmate-ready "
               "&& TMATE_CONNECT=\\$("
               "tmate display -p '#{tmate_ssh} # "
               user-buffer
               ".target # #{tmate_web} ') "
               "; echo \\$TMATE_CONNECT "
               "; (echo \\$TMATE_CONNECT | xclip -i -sel p -f | xclip -i -sel c ) 2>/dev/null "
               "; echo Share the above with your friends and hit enter when done. "
               "; read "
               "; bash --login\"")))
 (eval . (xclip-mode 1))
 (eval . (gui-select-text start-tmate-command))
 (eval . (xclip-mode 0))
 (eval . (setq tmate-command start-tmate-command))
 (eval . (with-current-buffer (get-buffer-create "start-tmate-command")
           (insert-for-yank (concat "\nOpen another terminal on the same host and paste:\n\n" tmate-command))))
 (eval . (switch-to-buffer "start-tmate-command"))
 (eval . (y-or-n-p "Have you Pasted?"))
 ;; (eval . (switch-to-buffer (get-buffer buffer-file-name)))
 ;; (eval . (spacemacs/toggle-maximize-buffer))
 ;; (eval . (set (make-local-variable 'org-babel-default-header-args:tmate) '(
 ;;                                                                          (:noweb . "yes")
 ;;                                                                          (:results . "silent")
 ;;                                                                          (:window . "main")
 ;;                                                                          (:terminal . "sakura")
 ;;                                                                          ;; (:socket . '(symbol-value . 'socket))
 ;;                                                                          (:socket . (concat socket "XXXXX"))
 ;;                                                                         )))
 ;; https://emacs.stackexchange.com/questions/26185/using-a-function-as-an-org-babel-header-argument
 (org-babel-default-header-args:tmate .
                                      (
                                       (:noweb . "yes")
                                       (:results . "silent")
                                       (:window . "main")
                                       (:terminal . "sakura2")
                                       ;; (:socket . org-file-dir)
                                       ;; (:socket . '(symbol-value . 'socket))
                                       ;; (:socket . '(concat "S" "YYY" "XXXXX"))
                                       ;; (:socket . (concat "S" socket "XXXXX"))
                                       )
                                      )
 (org-babel-default-header-args:shell .
                                      (
                                       (:noweb . "yes")
                                       (:results . "output code verbatim replace")
                                       (:exports . "both")
                                       (:wrap . "\"EXAMPLE :noeval t\"")
                                       (:eval . "no-export")
                                       ;; (:noweb-ref . "(nth 4 (org-heading-components))")
                                       )
                                      )
 (org-babel-default-header-args:json .
                                     (
                                      (:noweb . "yes")
                                      ;; (:noweb-ref . "(nth 4 (org-heading-components))")
                                      )
                                     )
 (org-babel-default-header-args:yaml .
                                     (
                                      (:noweb . "yes")
                                      (:comments . "org")
                                      ;; (:noweb-ref . "(nth 4 (org-heading-components))")
                                      )
                                     )
 ))
