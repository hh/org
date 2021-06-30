# FROM alpine:3.12 AS build
# ENV VERSION=2.85
# WORKDIR /app
# RUN apk add --no-cache git curl make linux-headers nettle-dev coreutils gcc libidn libidn-dev libnetfilter_conntrack libnetfilter_conntrack-dev
# RUN curl -o dnsmasq.tar.xz -L https://www.thekelleys.org.uk/dnsmasq/dnsmasq-$VERSION.tar.xz && \
#   tar xvf dnsmasq.tar.xz
# WORKDIR /app/dnsmasq-$VERSION
# RUN make COPTS="-DHAVE_DNSSEC -DHAVE_CONNTRACK -DHAVE_IDN -DHAVE_IDN_STATIC" all && \
#   mv src/dnsmasq src/dnsmasq~dnssec && \
#   make CFLAGS="$CFLAGS" clean all

FROM alpine:3.12 AS final
RUN apk add --no-cache tcpdump curl dnsmasq-dnssec
RUN mkdir -p /etc/default/ && \
  echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
ENTRYPOINT ["dnsmasq","--no-daemon"]
