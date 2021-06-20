# Container image

# Define the image

FROM postgres:12.2
RUN apt-get update && \
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
  libc6-dev
RUN pip3 install pyasn
