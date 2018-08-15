#!/usr/bin/env sh

mkdir -p /etc/acra-go
unset AUTH

if [ "$HTPASSWD_BACKEND" ]; then
    echo -n "$HTPASSWD_BACKEND" > /etc/acra-go/backend
    AUTH="--htpasswd-backend /etc/acra-go/backend $AUTH"
fi

if [ "$HTPASSWD_FRONTEND" ]; then
    echo -n "$HTPASSWD_FRONTEND" > /etc/acra-go/frontend
    AUTH="--htpasswd-frontend /etc/acra-go/frontend $AUTH"
fi

if [ $# -eq 0 ]; then
    /bin/acra-go serve --bind-addr :80 --database-dir /data $AUTH
else
    exec "$@"
fi
