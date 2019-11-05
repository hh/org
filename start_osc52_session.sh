#!/bin/bash
set -x
export ALTERNATE_EDITOR=""
BASE=$(basename $1)
OSC52E=$(dirname "${BASH_SOURCE[0]}")/osc52.sh
# ensure this TMATE starts shell with BASE=$BASE
tmate -S /tmp/${USER}.${BASE}.iisocket new-session \
      -A -s $USER -n emacs \
      "tmate wait tmate-ready \
&& TMATE_CONNECT=\
\$(tmate display -p '#{tmate_ssh} # ${USER}.${BASE} # $(date) # #{tmate_web}') \
; echo \$TMATE_CONNECT \
; (echo \$TMATE_CONNECT | $OSC52E ) \
; echo Share the above with your friends and hit enter here when done? \
; read ; \
emacsclient -s $BASE --tty $1 2>&1"
