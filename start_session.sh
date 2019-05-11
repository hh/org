#!/bin/bash
set -x
orgfile=$1
BASE=$(basename $orgfile)
tmate -S /tmp/${USER}.${BASE}.iisocket new-session \
      -A -s $USER -n emacs \
      "tmate wait tmate-ready \
&& TMATE_CONNECT=\$(tmate display -p '#{tmate_ssh} # ${USER}.${BASE} # $(date) # #{tmate_web}') \
; echo \$TMATE_CONNECT \
; (echo \$TMATE_CONNECT | xclip -i -sel p -f | xclip -i -sel c )2>/dev/null \
; echo Share the above with your friends and hit enter here when done? \
; read ; \
emacs -nw $1"
