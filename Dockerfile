FROM ubuntu:21.04

ARG CALIBRE_RELEASE=5.34.0
ARG TZ=Europe/Rome
ENV CALIBRE_RELEASE=${CALIBRE_RELEASE}
ENV TZ=${TZ}
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /srv

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -euv\
    ; ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    ; mkdir /books \
    ; apt-get update \
    ; apt-get upgrade -y \
    ; apt-get install -y --no-install-recommends \
        bash-completion \
        build-essential \
        ca-certificates \
        curl \
        glibc-source \
        libnss-mdns \
        libfreetype-dev \
        libhunspell-dev \
        libhyphen-dev \
        libicu-dev \
        libmtp-dev \
        libpodofo-dev \
        libpodofo-utils \
        libqt5charts5-dev \
        libsqlite3-dev \
        libstemmer-dev \
        libusb-1.0-0-dev \
        libusb-dev \
        pkg-config \
        pyqt5-dev \
        python3 \
        python3-apsw \
        python3-bs4 \
        python3-css-parser \
        python3-hunspell \
        python3-lxml \
        python3-msgpack \
        python3-regex \
        python3-dev \
        python3-dateutil \
        python3-distutils \
        python3-html5-parser \
        python3-pil \
        python3-pyqt5 \
        python3-pyqtbuild \
        python3-sipbuild \
        qconf \
        qt5-qmake \
        qt5-qmake-bin \
        qtbase5-dev \
        qtbase5-dev-tools \
        qtbase5-private-dev \
        qtchooser \
        xdg-utils \
        xz-utils \
    ; ln -s /usr/bin/python3 /usr/bin/python \
    ; curl -sL https://bootstrap.pypa.io/get-pip.py -o get-pyp.py \
    ; python get-pyp.py \
    ; pip install -U --no-cache-dir \
        zeroconf \
    ; curl -L https://github.com/kovidgoyal/calibre/releases/download/v$CALIBRE_RELEASE/calibre-$CALIBRE_RELEASE.tar.xz | tar xvJ \
    ; python3 ./calibre*/setup.py install \
    ; rm -rf /srv/* \
    ; curl -sLk -o /books/christmascarol.mobi http://www.gutenberg.org/ebooks/46.kindle.noimages \
    ; calibredb add /books/*.mobi --with-library /books \
    ; apt-get purge -y \
        *-dev \
        bash-completion \
        build-essential \
        pkg-config \
        qconf \
        qt5-qmake \
        qt5-qmake-bin \
        qtbase5-dev-tools \
    ; apt-get clean \
    ; rm -rf /var/lib/apt/lists/* \
    ; rm -rf /var/cache/apt \
    ;

EXPOSE 8085

ENTRYPOINT [ "/usr/bin/calibre-server", "--port=8085", "--enable-local-write", "--log=/dev/stdout", "--access-log=/dev/stdout", "--trusted-ips=192.168.0.0/16,172.16.0.0/12,10.0.0.0/8", "/books" ]