FROM golang:1.18-alpine AS fixidBuilder

WORKDIR /srv

RUN set -vue \
    ; apk add --no-cache git openssh-client shadow \
;

ARG FIXUID_VERSION=v0.5.1
RUN set -vue \
    ; git clone --single-branch --branch ${FIXUID_VERSION} https://github.com/boxboat/fixuid.git \
    ; cd fixuid \
    ; ./build.sh \
    ; chown root:root /srv/fixuid/fixuid \
    ; chmod 4775 /srv/fixuid/fixuid \
;

FROM debian:unstable AS Application

ARG ADMIN_PASSWORD="ChangeMe!"
ARG ENABLE_AUTH=false
ARG TZ=Europe/Rome
ENV ADMIN_PASSWORD=${ADMIN_PASSWORD}
ENV DEBIAN_FRONTEND=noninteractive
ENV ENABLE_AUTH=${ENABLE_AUTH}
ENV TZ=${TZ}

WORKDIR /srv

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -euv \
    ; ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    ; apt-get update \
    ; apt-get upgrade -y \
    ; apt-get install -y --no-install-recommends \
        curl \
        calibre \
    ; apt-get clean \
    ; rm -rf /var/lib/apt/lists/* \
    ; rm -rf /var/cache/apt \
    ; mkdir /books \
    ; mkdir /srv/calibre \
    ; groupadd -g 1001 calibre \
    ; useradd -d /books -g calibre -u 1001 calibre \
    ; chown -R calibre:calibre /books \
    ; chown -R calibre:calibre /srv/calibre \
;

RUN set -euv \
    ; USER=calibre \
    ; GROUP=calibre \
    ; mkdir -p /etc/fixuid \
    ; printf "user: $USER\ngroup: $GROUP\npaths:\n  - /\n  - /books\n  - /srv\n  - /srv/calibre" > /etc/fixuid/config.yml \
;

COPY --from=fixidBuilder /srv/fixuid/fixuid /usr/local/bin/
COPY --chown=calibre:calibre entrypoint.sh /srv/

USER calibre:calibre

RUN set -euv \
    ; curl -sLk -o /books/book.mobi https://www.smashwords.com/books/download/1136687/4/latest/0/0/Making-a-Realistic-Publishing-Schedule.mobi \
    ; calibredb add /books/*.mobi --with-library /books \
;

EXPOSE 8085

ENTRYPOINT [ "/srv/entrypoint.sh" ]