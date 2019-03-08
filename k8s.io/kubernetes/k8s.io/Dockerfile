FROM gcr.io/cloudshell-images/cloudshell:cloud-shell-v20190304

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

RUN apt-key adv \
  --keyserver keyserver.ubuntu.com \
  --recv-keys 6A030B21BA07F4FB \
  && add-apt-repository \
  "deb http://apt.kubernetes.io/ kubernetes-stretch main" \
  && apt-get update \
  && apt-get install -qy \
  kubectl

RUN add-apt-repository \
  "deb http://packages.cloud.google.com/apt cloud-sdk-stretch main" \
  && apt-get update \
  && apt-get install -y \
  google-cloud-sdk

RUN apt purge -yq \
  emacs24-bin-common \
  emacs24-common \
  emacs24-nox \
  emacs-nox \
  emacsen-common

RUN git clone --depth 1 -b stable \
    https://github.com/ii/elpa-mirror \
    /usr/local/elpa-mirror

RUN git clone --depth 1 -b stable \
    https://github.com/ii/emacs \
    /usr/local/src/emacs

RUN cd /usr/local/src/emacs \
    && ./autogen.sh \
    && ./configure --prefix=/usr/local \
    && make -j $(nproc) install

#RUN go get sigs.k8s.io/kind && cp /root/gopath/bin/kind /usr/local/bin

RUN curl -L \
  https://storage.googleapis.com/kubernetes-helm/helm-v2.13.0-linux-amd64.tar.gz \
  | tar xvz -f - --strip-components 1 -C /usr/local/bin linux-amd64/helm linux-amd64/tiller

RUN git clone --depth 1 -b stable --recurse-submodules \
    https://github.com/ii/spacemacs.git \
    /etc/skel/.emacs.d \
  && ln -s .emacs.d/private/local/dot-spacemacs/.spacemacs /etc/skel/.spacemacs

RUN  ln -sf /etc/skel/.emacs.d /root/.emacs.d \
  && ln -sf .emacs.d/private/local/dot-spacemacs/.spacemacs /root/.spacemacs \
  && emacs --batch -l ~/.emacs.d/init.el \
  && rm /root/.emacs.d /root/.spacemacs \
  && rm /etc/skel/.emacs.d/elpa/gnupg/S.gpg-agent*
