FROM ubuntu:21.10

ARG ADMIN_PASSWORD='ChangeMe!'
ARG CALIBRE_VERSION='5.37.0'
ARG ENABLE_AUTH=false
ARG TZ=Europe/Rome
ENV ADMIN_PASSWORD=${ADMIN_PASSWORD}
ENV DEBIAN_FRONTEND=noninteractive
ENV CALIBRE_VERSION=${CALIBRE_VERSION}
ENV ENABLE_AUTH=${ENABLE_AUTH}
ENV TZ=${TZ}

WORKDIR /srv

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -euv\
    ; ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    ; mkdir /books calibre\
    ; apt-get update \
    ; apt-get upgrade -y \
    ; apt-get install -y --no-install-recommends \
        curl \
        xz-utils \
        python3-pyqt5 \
    ; CPU_ARCHITECTURE="$(lscpu | grep Architecture | awk '{print $2}')" \
    ; curl -sLk -o calibre.txz "https://github.com/kovidgoyal/calibre/releases/download/v$CALIBRE_VERSION/calibre-$CALIBRE_VERSION-$CPU_ARCHITECTURE.txz" \
    ; tar xf calibre.txz -C calibre \
    ; PATH=$PATH:/srv/calibre \
    ; curl -sLk -o /books/christmascarol.mobi http://www.gutenberg.org/ebooks/46.kindle.noimages \
    ; calibredb add /books/*.mobi --with-library /books \
    ; apt-get clean \
    ; rm -rf /var/lib/apt/lists/* \
    ; rm -rf /var/cache/apt \
    ;

COPY entrypoint.sh /srv/

EXPOSE 8085

ENTRYPOINT [ "/srv/entrypoint.sh" ]