FROM iiusb:base
RUN echo 'Acquire::http { Proxy "http://192.168.1.15:8000"; }' \
  | sudo tee -a /etc/apt/apt.conf.d/proxy \
  && export DEBIAN_FRONTEND=noninteractive \
  && locale-gen --purge en_US.UTF-8 \
  && sed -i s:restricted:restricted\ universe: /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -yq \
    apt-file \
    apt-transport-https \
    aptitude \
    awesome \
    autoconf \
    build-essential \
    byzanz \
    ca-certificates \
    debian-goodies \
    curl \
    figlet \
    git \
    gpg \
    gtk-redshift \
    htop \
    jq \
    kvmtool \
    linux-headers-generic \
    locales \
    lolcat \
    macchanger \
    nmap \
    pass \
    qemu-kvm \
    sakura \
    silversearcher-ag \
    software-properties-common \
    strace \
    sudo \
    texinfo \
    thunar \
    tig \
    tmate \
    tmux \
    tshark \
    unzip \
    whois \
    wireshark \
    vlc \
    xfonts-terminus \
    xfonts-terminus-dos \
    xfonts-terminus-oblique \
    zfs-initramfs \
    zfsutils-linux \
    zip

RUN apt-key adv \
  --keyserver keyserver.ubuntu.com \
  --recv-keys 6A030B21BA07F4FB \
  && add-apt-repository \
  "deb http://apt.kubernetes.io/ kubernetes-xenial main" \
  && apt-get install -y \
  kubelet kubeadm kubectl

RUN add-apt-repository \
  "deb http://packages.cloud.google.com/apt cloud-sdk-disco main" \
  && apt-get install -y \
  google-cloud-sdk

RUN apt-key adv \
  --recv-keys 9DC858229FC7DD38854AE2D88D81803C0EBFCD88 \
  && add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu cosmic stable" \
  && apt-get install -y \
  docker-ce

RUN apt-key adv \
  --keyserver keyserver.ubuntu.com \
  --recv-keys 52B59B1571A79DBC054901C0F6BC817356A3D45E \
  && add-apt-repository \
  "deb http://ppa.launchpad.net/longsleep/golang-backports/ubuntu cosmic main" \
  && apt-get install -y \
  golang-1.12 \
  && echo 'export PATH=$PATH:$HOME/go/bin' \
     > /etc/profile.d/homedir-go-path.sh \
  && echo 'export PATH=/usr/lib/go-1.12/bin:$PATH' \
     > /etc/profile.d/system-go-path.sh

RUN curl -L \
  https://storage.googleapis.com/kubernetes-helm/helm-v2.14.1-linux-amd64.tar.gz \
  | tar xvz -f - --strip-components 1 -C /usr/local/bin linux-amd64/helm linux-amd64/tiller

RUN apt-key adv \
  --keyserver keyserver.ubuntu.com \
  --recv-keys 9FD3B784BC1C6FC31A8A0A1C1655A0AB68576280 \
  && add-apt-repository \
  "deb https://deb.nodesource.com/node_11.x disco main" \
  && apt-get install -y \
  nodejs

RUN apt-key adv \
  --keyserver keyserver.ubuntu.com \
  --recv-keys EB4C1BFD4F042F6DDDCCEC917721F63BD38B4796 \
  && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update \
  && apt-get install -y \
  google-chrome-stable

RUN apt-key adv \
  --keyserver keyserver.ubuntu.com \
  --recv-keys 59FDA1CE1B84B3FAD89366C027557F056DC33CA5 \
  && add-apt-repository \
  "deb http://ppa.launchpad.net/fish-shell/release-3/ubuntu disco main" \
  && apt-get install -y \
  fish

RUN apt-get install -y ibus libgl1-mesa-glx \
  && apt-key adv \
   --keyserver keyserver.ubuntu.com \
   --recv-keys 396060CADD8A75220BFCB369B903BF1861A7C71D \
  && curl -L -o /tmp/zoom.deb \
     https://zoom.us/client/latest/zoom_amd64.deb \
  && dpkg -i /tmp/zoom.deb \
  && rm /tmp/zoom.deb

RUN apt-get install -y emacs

RUN apt-key adv \
  --keyserver keyserver.ubuntu.com \
  --recv-keys B9F8D658297AF3EFC18D5CDFA2F683C52980AECF \
  && add-apt-repository \
  "deb http://download.virtualbox.org/virtualbox/debian bionic contrib" \
  && apt-get install -y \
  virtualbox-6.0

RUN git clone --depth 1 --recurse-submodules \
    https://github.com/iimacs/site-lisp \
    /usr/local/share/emacs/site-lisp

RUN emacs --batch -l /usr/local/share/emacs/site-lisp/default.el
RUN mv /root/.emacs.d /root/.spacemacs /etc/skel \
  && rm -f /etc/skel/.emacs.d/elpa/gnupg/S.gpg-agent*

RUN cd /tmp \
  && wget https://github.com/jgm/pandoc/releases/download/2.7.3/pandoc-2.7.3-1-amd64.deb \
  && dpkg -i pandoc-2.7.3-1-amd64.deb \
  && rm pandoc-2.7.3-1-amd64.deb
