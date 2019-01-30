# [[file:~/ii/org/emacs.org::*Install%20and%20Configure%20tmate][Install and Configure tmate:1]]
sudo apt-get install -y tmate
# Install and Configure tmate:1 ends here

# [[file:~/ii/org/emacs.org::*Install%20and%20Configure%20tmate][Install and Configure tmate:2]]
cat <<EOF > ~/.tmate.conf
set-option -g set-clipboard on
set-option -g mouse on
set-option -g history-limit 50000
set -g tmate-server-host pair.ii.nz
set -g tmate-server-port 22
set -g tmate-server-rsa-fingerprint   "f9:af:d5:f2:47:8b:33:53:7b:fb:ba:81:ba:37:d3:b9"
set -g tmate-server-ecdsa-fingerprint   "32:44:b3:bb:b3:0a:b8:20:05:32:73:f4:9a:fd:ee:a8"
set -g tmate-identity ""
set -s escape-time 0
EOF
# Install and Configure tmate:2 ends here

# [[file:~/ii/org/emacs.org::Debian][Debian]]
if [ $(lsb_release -i -s) == "Debian" ] ; then
  CODENAME=$(lsb_release -c -s)
  sudo apt-key adv \
  --recv-keys AD287B4E92138B93 \
  && sudo add-apt-repository \
  "deb http://emacs.ganneff.de/ $CODENAME main" \
  && sudo apt-get install -y \
  emacs-snapshot
fi
# Debian ends here

# [[file:~/ii/org/emacs.org::Ubuntu][Ubuntu]]
if [ $(lsb_release -i -s) == "Ubuntu" ] ; then
  CODENAME=$(lsb_release -c -s)
  sudo apt-key adv \
  --recv-keys 0D7BAE435ADBC6C3E4918A74062D648FD62FCE72 \
  && sudo add-apt-repository \
  "deb http://ppa.launchpad.net/ubuntu-elisp/ppa/ubuntu $CODENAME main" \
  && sudo apt-get install -y \
  emacs-snapshot
fi
# Ubuntu ends here

# [[file:~/ii/org/emacs.org::*ELPA%20Mirror][ELPA Mirror:1]]
sudo git clone --depth 1 -b stable \
    https://github.com/ii/elpa-mirror \
    /usr/local/elpa-mirror
# ELPA Mirror:1 ends here

# [[file:~/ii/org/emacs.org::*Configuring%20Emacs][Configuring Emacs:1]]
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
# Configuring Emacs:1 ends here

# [[file:~/ii/org/emacs.org::*Compiling%20Elisp%20Configuration%20/%20Installing%20Packages][Compiling Elisp Configuration / Installing Packages:1]]
emacs --batch -l ~/.emacs.d/init.el
# Compiling Elisp Configuration / Installing Packages:1 ends here

# [[file:~/ii/org/emacs.org::*Request%20they%20configure%20gitlab][Request they configure gitlab:1]]
echo Add something like the following to your ~/.gitconfig
cat <<EOF
[user]
  email = hh@ii.coop
  name = Hippie Hacker
[alias]
  lol = log --graph --decorate --pretty=oneline --abbrev-commit --all
  create-pull-request = !sh -c 'stash pull-request $0'
  lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
EOF
# Request they configure gitlab:1 ends here
