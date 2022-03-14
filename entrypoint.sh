#!/usr/bin/env bash

function create_user_db {
    /usr/bin/calibre-server \
        --userdb /srv/calibre/users.sqlite \
        --manage-users add admin "${ADMIN_PASSWORD}"
}

if "${ENABLE_AUTH}"; then
    if [ -f /srv/calibre/users.sqlite ]; then
        /usr/bin/calibre-server \
            --enable-auth \
            --userdb /srv/calibre/users.sqlite \
            --port=8085 \
            --enable-local-write \
            --log=/dev/stdout \
            --access-log=/dev/stdout \
            --trusted-ips=192.168.0.0/16,172.16.0.0/12,10.0.0.0/8 \
            /books
    else
        create_user_db
        /usr/bin/calibre-server \
            --enable-auth \
            --userdb /srv/calibre/users.sqlite \
            --port=8085 \
            --enable-local-write \
            --log=/dev/stdout \
            --access-log=/dev/stdout \
            --trusted-ips=192.168.0.0/16,172.16.0.0/12,10.0.0.0/8 \
            /books
    fi
else
    /usr/bin/calibre-server \
        --port=8085 \
        --enable-local-write \
        --log=/dev/stdout \
        --access-log=/dev/stdout \
        --trusted-ips=192.168.0.0/16,172.16.0.0/12,10.0.0.0/8 \
        /books
fi