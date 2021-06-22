FROM postgres:12.2
RUN apt-get update && \
  apt-get install -y curl && \
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
    | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
  apt-get update && \
  apt-get install  -y --no-install-recommends \
  python3 \
  python3-dev \
  python3-pip \
  python3-wheel \
  python3-setuptools \
  jq \
  curl \
  git \
  gcc \
  libc6-dev \
  google-cloud-sdk && \
  rm -rf /var/lib/apt/lists/*
RUN pip3 install pyasn
WORKDIR /app
COPY ./pg-init.d docker-entrypoint-initdb.d
COPY ./app .
