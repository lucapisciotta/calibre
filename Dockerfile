FROM debian:unstable

ARG ADMIN_PASSWORD="ChangeMe!"
ARG ENABLE_AUTH=false
ARG TZ=Europe/Rome
ENV ADMIN_PASSWORD=${ADMIN_PASSWORD}
ENV DEBIAN_FRONTEND=noninteractive
ENV ENABLE_AUTH=${ENABLE_AUTH}
ENV TZ=${TZ}

WORKDIR /srv

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -euv\
    ; ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    ; apt-get update \
    ; apt-get upgrade -y \
    ; apt-get install -y --no-install-recommends \
        curl \
        calibre \
        sudo \
    ; apt-get clean \
    ; rm -rf /var/lib/apt/lists/* \
    ; rm -rf /var/cache/apt \
    ; mkdir /books \
    ; useradd -d /books -U calibre \
    ; chown -R calibre:calibre /books \
    # This line is necessary to permit a custom UID/GID
    ; echo 'calibre ALL=(ALL) NOPASSWD: /usr/sbin/groupmod' >> /etc/sudoers.d/calibre \
    ;

USER calibre

RUN set -euv \
    ; curl -sLk -o /books/book.mobi https://www.smashwords.com/books/download/1136687/4/latest/0/0/Making-a-Realistic-Publishing-Schedule.mobi \
    ; calibredb add /books/*.mobi --with-library /books \
    ;

COPY --chown=calibre:calibre entrypoint.sh /srv/

EXPOSE 8085

ENTRYPOINT [ "/srv/entrypoint.sh" ]