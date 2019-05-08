#!/bin/bash
set -x
orgfile=$1
BASE=$(basename $orgfile)
tmate -S /tmp/${USER}.${BASE}.iisocket new-session \
      -A -s $USER -n emacs \
      "tmate wait tmate-ready \
&& tmate display -p \
  '#{tmate_ssh} # ${USER}.${BASE} # #{tmate_web}' \
| xclip -i -sel p -f | xclip -i -sel c \
; sleep 0.05 \
; xclip -o \
; echo Have you Pasted? \
; read ; \
emacs -nw $1"
