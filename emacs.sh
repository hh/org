sudo apt-key adv \
  --recv-keys 0D7BAE435ADBC6C3E4918A74062D648FD62FCE72 \
  && sudo add-apt-repository \
  "deb http://ppa.launchpad.net/ubuntu-elisp/ppa/ubuntu bionic main" \
  && sudo apt-get install -y \
  emacs-snapshot

sudo git clone --depth 1 -b stable \
    https://github.com/ii/elpa-mirror \
    /usr/local/elpa-mirror

git clone --depth 1 -b stable \
    https://github.com/ii/spacemacs.git \
    ~/.emacs.d \
  && git clone --depth 1 \
    https://gitlab.ii.coop/ii/tooling/ob-tmate.git \
    ~/.emacs.d/private/local/ob-tmate.el \
  && git clone --depth 1 -b stable \
    https://gitlab.ii.coop/ii/tooling/dot-spacemacs.git \
    ~/.emacs.d/private/local/dot-spacemacs \
  && ln -s .emacs.d/private/local/dot-spacemacs/.spacemacs ~/.spacemacs \
  && ln -sf private/local/dot-spacemacs/.lock ~/.emacs.d/.lock

emacs --batch -l ~/.emacs.d/init.el
