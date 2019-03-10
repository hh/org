# Dockerfile
#    :PROPERTIES:
#    :header-args: dockerfile  :tangle Dockerfile :comments org
#    :END:

# #+NAME: start from the base Google Cloud-Shell

FROM gcr.io/cloudshell-images/cloudshell:cloud-shell-v20190304

# Base Software
 
# #+NAME: wg-k8s-infra Dockerfile

RUN locale-gen --purge en_US.UTF-8 \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
  apt-file \
  aptitude \
  debian-goodies \
  figlet \
  gnupg \
  libgnutls28-dev \
  lolcat \
  nmap \
  pass \
  silversearcher-ag \
  texinfo \
  tmate \
  tshark \
  xclip

# Update Kubectl

# #+NAME: Kubernetes

RUN apt-key adv \
  --keyserver keyserver.ubuntu.com \
  --recv-keys 6A030B21BA07F4FB \
  && add-apt-repository \
  "deb http://apt.kubernetes.io/ kubernetes-stretch main" \
  && apt-get update \
  && apt-get install -qy \
  kubectl

# Google Cloud SDK

# https://cloud.google.com/sdk/docs/quickstart-debian-ubuntu

# Uses the same apt-key as kubernetes.

# #+NAME: Google SDK

RUN add-apt-repository \
  "deb http://packages.cloud.google.com/apt cloud-sdk-stretch main" \
  && apt-get update \
  && apt-get install -y \
  google-cloud-sdk

# Emacs

# ii emacs+spacemacs+tmate requires our pinned/stable versions
# - elpa-mirror
# - emacs
# - spacemacs

# #+NAME: Remove emacs24

RUN apt purge -yq \
  emacs24-bin-common \
  emacs24-common \
  emacs24-nox \
  emacs-nox \
  emacsen-common



# #+NAME: configure-elpa-mirror

RUN git clone --depth 1 -b stable \
    https://github.com/ii/elpa-mirror \
    /usr/local/elpa-mirror



# #+NAME: configure-elpa-mirror

RUN curl -L \
  https://storage.googleapis.com/apisnoop/ii-emacs.tgz \
  | tar xvz -f - -C / \
  && ln -s /usr/local/emacs/bin/* /usr/local/bin

# kind

# #+NAME: kind

#RUN go get sigs.k8s.io/kind && cp /root/gopath/bin/kind /usr/local/bin

# helm

# #+NAME helm

RUN curl -L \
  https://storage.googleapis.com/kubernetes-helm/helm-v2.13.0-linux-amd64.tar.gz \
  | tar xvz -f - --strip-components 1 -C /usr/local/bin linux-amd64/helm linux-amd64/tiller

# Configuring Emacs in /etc/skel

# We use spacemacs, and it takes a while to download / configure / compile all the
# lisp files.

# One of the larger components that is much faster to have local is our elpa-mirror.

# Here we attempt to put our config into /etc/skel

# /etc/skel/.emacs.d and /etc/skel/.spacemacs will be copied to all new users
# $HOME

# #+NAME: configure-emacs

RUN git clone --depth 1 -b stable --recurse-submodules \
    https://github.com/ii/spacemacs.git \
    /etc/skel/.emacs.d \
  && ln -s .emacs.d/private/local/dot-spacemacs/.spacemacs /etc/skel/.spacemacs



# On first start, emacs will want to compile all our elisp files. Instead we copy
# symlink from root, and compile everything via a batch run of init.el, then
# remove the symlink.

# This means startup time for the user will be greatly reduced.
# The S.gpg-agent.* files are sockets, and don't work well being in /etc/skel.

# #+BEGIN_EXAMPLE
# Copying files from `/etc/skel' ...
# Stopped: Cannot deal with /etc/skel/./.emacs.d/elpa/gnupg/S.gpg-agent.ssh.
# It is not a dir, file, or symlink.
# #+END_EXAMPLE

# #+NAME: compile-elisp

RUN  ln -sf /etc/skel/.emacs.d /root/.emacs.d \
  && ln -sf .emacs.d/private/local/dot-spacemacs/.spacemacs /root/.spacemacs \
  && emacs --batch -l ~/.emacs.d/init.el \
  && rm /root/.emacs.d /root/.spacemacs \
  && rm /etc/skel/.emacs.d/elpa/gnupg/S.gpg-agent*
