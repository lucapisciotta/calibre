FROM debian:stable-slim

ARG TZ=Europe/Rome
ENV TZ=${TZ}
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /srv

RUN set -ue \
    ; ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    ; apt-get update \
    ; apt-get upgrade -y \
    ; apt-get install -y \
        curl \
        calibre \
    ;

RUN set -ue \
    ; apt-get autoremove \
    ; apt-get clean \
    ; apt-get autoclean \
    ;

EXPOSE 8085

ENTRYPOINT [ "calibre-server", "--port=8085", "--access-log=/dev/stdout", "/books" ]