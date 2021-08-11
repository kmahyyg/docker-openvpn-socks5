FROM alpine:edge AS downloader

COPY downloader.sh /downloader.sh
RUN apk update && \
    apk add --no-cache bash curl ca-certificates grep && \
    chmod +x /downloader.sh && \
    bash /downloader.sh


FROM alpine:edge

COPY --from=downloader /gost /usr/bin/gost
COPY --from=downloader /update-resolv-conf.sh /usr/bin/openvpn-update-resolv-conf.sh
COPY entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN apk update && \
    apk add --no-cache bash s6 openresolv openvpn && \
    mkdir -p /etc/openvpn && \
    chmod +x /usr/bin/gost /usr/bin/openvpn-update-resolv-conf.sh /usr/bin/docker-entrypoint.sh 

EXPOSE 3128 1080
VOLUME ["/config/vpn"]
ENV OVERRIDE_HTTP_ARGS=0.0.0.0:3128
ENV OVERRIDE_SOCKS_ARGS=0.0.0.0:1080
ENV APPEND_PROXY_HTTP_ARGS=""
ENV APPEND_PROXY_SOCKS_ARGS=""

ENTRYPOINT [ "/usr/bin/docker-entrypoint.sh" ]
