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
                  ":noweb-ref " item-str
                  " :session (concat user-login-name \":\" " item-str ")"
                  " :socket " socket
                  ))
           (cons 'header-args:emacs-lisp
                 (concat
                  ":noweb-ref " item-str
                  ))
           (cons 'header-args:elisp
                 (concat
                  ":noweb-ref " item-str
                  ))
           (cons 'header-args:bash
                 (concat
                  ":noweb-ref " item-str
                  ))
           (cons 'header-args:bash
                 (concat
                  ":noweb-ref " item-str
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
           " -n main \"tmate wait tmate-ready "
           "&& TMATE_CONNECT=\\$("
           "tmate display -p '#{tmate_ssh} # "
           user-buffer
           ".target # #{tmate_web} ') "
           "; echo \\$TMATE_CONNECT "
           "; (echo \\$TMATE_CONNECT | xclip -i -sel p -f | xclip -i -sel c ) 2>/dev/null "
           "; echo Share the above with your friends and hit enter when done. "
           "; read "
           "; bash --login\""
           )
          )
     ;; (edebug-trace "TRACING socket:%S" socket)
     ;; (edebug-trace "TRACING org-babel-header-args:tmate %S" org-babel-header-args:emacs-lisp)
     (xclip-mode 1)
     (gui-select-text start-tmate-command)
     (xclip-mode 0)
     ;; we could try and create a buffer / clear it on the fly
     (setq tmate-command start-tmate-command)
     (with-current-buffer (get-buffer-create "start-tmate-command")
       (insert-for-yank
        (concat "\nOpen another terminal on the same host and paste:\n\n" tmate-command)
        ))
     (switch-to-buffer "start-tmate-command")
     (y-or-n-p "Have you Pasted?")
     ;;; FIXME! How do we find out what our local filname is?
     ;;; This was designed for dir-locals... can we reach in?
     ;; (switch-to-buffer (get-buffer buffer-file-name))
     ;; (spacemacs/toggle-maximize-buffer)
     )
   )
  )
 )
 ;; (eval . (set (make-local-variable 'select-enable-clipboard) t))
 ;; (eval . (set (make-local-variable 'select-enable-primary) t))
 ;; (eval . (set (make-local-variable 'start-tmate-command)
              ;; ( ;; (eval . (set (make-local-variable 'org-babel-default-header-args:emacs-lisp)
 ;;              (:dir-local-default-func . (concat "DIR" "-EMACS_LISP"))
 ;;              ))
 ;; (eval . (edebug-trace "TRACING socket:%S" socket))
 ;; (eval . (edebug-trace "TRACING org-babel-header-args:emacs-lisp %S" org-babel-header-args:emacs-lisp))
 ;; (eval . (edebug-trace "TRACING org-babel-default-header-args:emacs-lisp %S" org-babel-default-header-args:emacs-lisp))
 ;; (eval . (edebug-trace "AFTERTRACING org-babel-header-args:emacs-lisp %S" org-babel-header-args:emacs-lisp))
 ;; (eval . (edebug-trace "AFTERTRACING org-babel-default-header-args:emacs-lisp %S" org-babel-default-header-args:emacs-lisp))
;               (list
;;                (:dir-local-eval-func . (concat "DIR-FUNC" "-EMACS_LISP"))
;;                (:dir-local-eval-quote . '(concat "DIR-QUOTE" "-EMACS_LISP"))
;;                (:dir-local-eval-str . "(concat \"DIR-STR\" \"-EMACS_LISP\")")
;;                )))
;; ;
                                        ; (eval . (xclip-mode 1))
 ;; (eval . (gui-select-text start-tmate-command))
 ;; (eval . (xclip-mode 0))
 ;; (eval . (setq tmate-command start-tmate-command))
 ;; (eval . (with-current-buffer (get-buffer-create "start-tmate-command")
 ;;           (insert-for-yank (concat "\nOpen another terminal on the same host and paste:\n\n" tmate-command))))
 ;; (eval . (switch-to-buffer "start-tmate-command"))
 ;; (eval . (y-or-n-p "Have you Pasted?"))
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
 ;; (org-babel-default-header-args:elisp .
 ;;                                      (
 ;;                                       (:dir-default . (concat "DIR" "-ELISP"))
 ;;                                       (:results . "code")
 ;;                                       )
 ;;                                      )
  ;; (org-babel-header-args:emacs-lisp .
  ;;                                  (
  ;;                                   (:dir-local-func . (concat "DIR" "-EMACS_LISP"))
  ;;                                   (:dir-local-quote . '(concat "DIR" "-EMACS_LISP"))
  ;;                                   (:dir-local-str . "(concat \"DIR\" \"-EMACS_LISP\")")
  ;;                                   )
  ;;                                  )
;; (org-babel-default-header-args:tmate .
;;                                       (
;;                                        (:noweb . "yes")
;;                                        (:results . "silent")
;;                                        (:window . "main")
;;                                        (:terminal . "sakura2")
;;                                        ;; (:noweb-ref . '(nth 4 (org-heading-components)))
;;                                        ;; (:socket . org-file-dir)
;;                                        ;; (:socket . '(symbol-value . 'socket))
;;                                        ;; (:socket . '(concat "S" "YYY" "XXXXX"))
;;                                        ;; (:socket . (concat "S" socket "XXXXX"))
;;                                        )
;;                                       )
;; ;; https://stackoverflow.com/questions/13228001/org-mode-nested-properties
;; (org-babel-default-header-args:shell .
;;                                       (
;;                                        (:noweb . "yes")
;;                                        (:results . "output code verbatim replace")
;;                                        (:exports . "both")
;;                                        (:wrap . "\"EXAMPLE :noeval t\"")
;;                                        (:eval . "no-export")
;;                                        ;; (:noweb-ref . "(nth 4 (org-heading-components))")
;;                                        )
;;                                       )
;;  (org-babel-default-header-args:json .
;;                                      (
;;                                       (:noweb . "yes")
;;                                       ;; (:noweb-ref . "(nth 4 (org-heading-components))")
;;                                       )
;;                                      )
;;  (org-babel-default-header-args:yaml .
;;                                      (
;;                                       (:noweb . "yes")
;;                                       (:comments . "org")
;;                                       ;; (:noweb-ref . "(nth 4 (org-heading-components))")
;;                                       )
;;                                      )
;;  ))
;; (eval . (set (make-local-variable 'user-buffer)
;;              (concat user-login-name "." (file-name-base load-file-name))))
;; (eval . (set (make-local-variable 'tmpdir)
;;              (make-temp-file (concat "/dev/shm/" user-buffer "-") t)))
;; (eval . (set (make-local-variable 'socket)
;;             (concat "/tmp/" user-buffer ".iisocket")))
;; (eval
;;  .
;;  (progn
;;    (let (
;;          (user-buffer
;;           (concat user-login-name "." (file-name-base load-file-name)))
;;          (socket
;;           (concat "/tmp/" user-buffer ".iisocket"))
;;          (socket-arch
;;           (concat ":socket " socket))
;;          )
;;      (
;;       (set (make-local-variable 'org-global-properties)
;;            '(
;;             (header-args:emacs-lisp . socket)
;;             )
;;            )
;;       )
;;      )
;;    )
;;  )

;; (org-global-properties .
;;                        (
;;                         (header-args:emacs-lisp . (concat ":tangle FOO"))
;;                         (header-args:elisp . (concat ":tangle BAR"))
;;                         ;; (header-args:emacs-lisp . (concat ":socket (symbol-value 'socket)"))
;;                         ;; (header-args:elisp . (concat ":socket (symbol-value 'socket)"))
;;                         )
;;                        )
;; (:socket . socket)
;; (org-babel-default-header-args:emacs-lisp .
;;                                           (
;;  (:dir-local-default-func . (concat "DIR" "-EMACS_LISP"))
;;  (:dir-local-default-quote . '(concat "DIR" "-EMACS_LISP"))
;;  (:dir-local-str . "(concat \"DIR\" \"-EMACS_LISP\")")
;;  )
;;                                           )
;; (eval . (set
;;          (make-local-variable
;;           'org-babel-default-header-args:emacs-lisp)
;;          '(
;;            (:dir-local-default-func . (concat "DIR" "-EMACS_LISP"))
;;            (:dir-local-default-quote . '(concat "DIR" "-EMACS_LISP"))
;;            (:dir-local-str . "(concat \"DIR\" \"-EMACS_LISP\")")
;;            )
;;           ))
