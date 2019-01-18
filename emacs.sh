sudo apt-get install -y tmate

cat <<EOF > ~/.tmate.conf
set-option -g set-clipboard on
set-option -g mouse on
set-option -g history-limit 50000
# ii tmate -- pair.ii.coop
set -g tmate-server-host pair.ii.nz
set -g tmate-server-port 22
set -g tmate-server-rsa-fingerprint   "f9:af:d5:f2:47:8b:33:53:7b:fb:ba:81:ba:37:d3:b9"
set -g tmate-server-ecdsa-fingerprint   "32:44:b3:bb:b3:0a:b8:20:05:32:73:f4:9a:fd:ee:a8"
set -g tmate-identity ""
set -s escape-time 0   
EOF

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
  && git clone --depth 1 \
    https://gitlab.ii.coop/ii/tooling/dot-spacemacs.git \
    ~/.emacs.d/private/local/dot-spacemacs \
  && ln -s .emacs.d/private/local/dot-spacemacs/.spacemacs ~/.spacemacs \
  && ln -sf private/local/dot-spacemacs/.lock ~/.emacs.d/.lock

emacs --batch -l ~/.emacs.d/init.el

Add the following to your ~/.gitconfig
cat <<EOF
[user]
  email = hh@ii.coop
  name = Hippie Hacker
[alias]
  lol = log --graph --decorate --pretty=oneline --abbrev-commit --all
  create-pull-request = !sh -c 'stash pull-request $0'
  lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
EOF
