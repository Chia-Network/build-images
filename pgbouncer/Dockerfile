# The latest version of pgbouncer is determined by what's in Alpine's package repositories.
# When updating either Alpine or PgBouncer, check the versions available here: https://pkgs.alpinelinux.org/packages?name=pgbouncer&branch=v3.24&repo=&arch=x86_64&origin=&flagged=&maintainer=
ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

ARG PGBOUNCER_VERSION
RUN apk add --no-cache \
    pgbouncer=${PGBOUNCER_VERSION}-r0 \
    tini \
    && rm -rf /var/cache/apk/*

RUN addgroup -g 1000 pgbouncer && \
    adduser -D -s /bin/sh -u 1000 -G pgbouncer pgbouncer

RUN mkdir -p /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer && \
    chown -R pgbouncer:pgbouncer /etc/pgbouncer /var/log/pgbouncer /var/run/pgbouncer

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set default environment variables
ENV PGBOUNCER_LISTEN_ADDR=0.0.0.0
ENV PGBOUNCER_LISTEN_PORT=6432
ENV PGBOUNCER_AUTH_TYPE=md5
ENV PGBOUNCER_AUTH_FILE=/etc/pgbouncer/userlist.txt
ENV PGBOUNCER_MAX_CLIENT_CONN=100
ENV PGBOUNCER_DEFAULT_POOL_SIZE=20
ENV PGBOUNCER_MAX_DB_CONNECTIONS=0
ENV PGBOUNCER_MAX_USER_CONNECTIONS=0
ENV PGBOUNCER_SERVER_RESET_QUERY="DISCARD ALL"
ENV PGBOUNCER_LOGFILE=/var/log/pgbouncer/pgbouncer.log
ENV PGBOUNCER_PIDFILE=/var/run/pgbouncer/pgbouncer.pid
ENV PGBOUNCER_IGNORE_STARTUP_PARAMETERS=extra_float_digits
ENV PGBOUNCER_APPLICATION_NAME_ADD_HOST=0
ENV PGBOUNCER_LOG_CONNECTIONS=1
ENV PGBOUNCER_LOG_DISCONNECTIONS=1
ENV PGBOUNCER_LOG_POOLER_ERRORS=1
ENV PGBOUNCER_SERVER_LIFETIME=3600
ENV PGBOUNCER_SERVER_IDLE_TIMEOUT=600
ENV PGBOUNCER_SERVER_CONNECT_TIMEOUT=15
ENV PGBOUNCER_SERVER_LOGIN_RETRY=15
ENV PGBOUNCER_QUERY_TIMEOUT=0
ENV PGBOUNCER_QUERY_WAIT_TIMEOUT=120
ENV PGBOUNCER_CLIENT_IDLE_TIMEOUT=0
ENV PGBOUNCER_CLIENT_LOGIN_TIMEOUT=60
ENV PGBOUNCER_AUTODB_IDLE_TIMEOUT=3600
ENV PGBOUNCER_DNS_NXDOMAIN_TTL=15
ENV PGBOUNCER_DNS_ZONE_CHECK_PERIOD=0
ENV PGBOUNCER_DNS_MAX_TTL=15

# Database connection environment variables
ENV PGBOUNCER_DB_HOST=localhost
ENV PGBOUNCER_DB_PORT=5432
ENV PGBOUNCER_DB_NAME=postgres
ENV PGBOUNCER_DB_USER=postgres
ENV PGBOUNCER_DB_PASSWORD=""

EXPOSE 6432

USER pgbouncer

ENTRYPOINT ["tini", "--", "/usr/local/bin/entrypoint.sh"]
