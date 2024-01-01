# https://github.com/jpillora/docker-dnsmasq/blob/master/Dockerfile

FROM alpine:edge
LABEL maintainer="dev@jpillora.com"
# webproc release settings
ENV WEBPROC_VERSION 0.2.2
ENV WEBPROC_URL https://github.com/jpillora/webproc/releases/download/$WEBPROC_VERSION/webproc_linux_amd64.gz
# fetch dnsmasq and webproc binary
RUN apk update \
 && apk --no-cache add dnsmasq tcpdump git \
 && apk add --no-cache --virtual .build-deps curl \
 && curl -sL $WEBPROC_URL | gzip -d - > /usr/local/bin/webproc \
 && chmod +x /usr/local/bin/webproc \
 && apk del .build-deps
#configure dnsmasq
RUN mkdir -p /etc/default/
RUN echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
RUN git clone --depth 1 https://github.com/Hexxeh/rpi-firmware.git \
    && mv rpi-firmware /tftpboot
COPY dnsmasq.conf /etc/dnsmasq.conf
#run!
ENTRYPOINT ["webproc","--config","/etc/dnsmasq.conf","--","dnsmasq","--no-daemon"]
