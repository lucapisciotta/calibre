FROM ubuntu:21.04

ARG TZ=Europe/Rome
ENV TZ=${TZ}
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /srv

RUN set -euv \
    ; ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    ; mkdir /books \
    ; apt-get update \
    ; apt-get upgrade -y \
    ; apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        xdg-utils \
        xz-utils \
        glibc-source \
        python3 \
        python3-pyqt5 \
        # wget \
    ; ln -s /usr/bin/python3 /usr/bin/python \
    ; curl -sLk -o /srv/linux-installer.sh https://download.calibre-ebook.com/linux-installer.sh \
    ; bash /srv/linux-installer.sh \
    ; curl -sLk -o  /books/christmascarol.mobi http://www.gutenberg.org/ebooks/46.kindle.noimages \
    ; calibredb add /books/*.mobi --with-library /books \
    ; apt-get purge -y wget \
    ; apt-get clean \
    ; rm -rf /var/lib/apt/lists/* \
    ; rm -rf /var/cache/apt \
    ;

EXPOSE 8085

ENTRYPOINT [ "/usr/bin/calibre-server", "--port=8085", "--access-log=/dev/stdout", "/books" ]