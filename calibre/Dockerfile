
FROM ubuntu:latest

ARG calibre_version=5.12.0+dfsg-1
ARG curl_version=7.74.0-1.3+b1
ARG TZ=Europe/Rome
ENV calibre_version=${calibre_version}
ENV curl_version=${curl_version}
ENV TZ=${TZ}

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /srv

RUN set -vue \
    ; ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    ; apt-get update \
    ; apt-get upgrade -y \
    ; apt-get install -y --no-install-recommends \
        curl=$curl_version \
        calibre=$calibre_version \
    ; apt-get clean \
    ; rm -rf /var/lib/apt/lists/*

EXPOSE 8085

ENTRYPOINT [ "calibre-server", "--port=8085", "--access-log=/dev/stdout", "/books" ]