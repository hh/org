FROM alpine:3.12 AS final
RUN apk add --no-cache tcpdump curl dnsmasq-dnssec
# TODO run as non-root
RUN mkdir -p /etc/default/ && \
  echo -e "ENABLED=1\nIGNORE_RESOLVCONF=yes" > /etc/default/dnsmasq
ENTRYPOINT ["dnsmasq","--no-daemon"]
