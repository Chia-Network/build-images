#!/bin/sh

# Generate pgbouncer.ini from environment variables
cat <<EOF > /etc/pgbouncer/pgbouncer.ini
[databases]
* = host=${PGBOUNCER_DB_HOST:-localhost} port=${PGBOUNCER_DB_PORT:-5432} dbname=${PGBOUNCER_DB_NAME:-postgres} user=${PGBOUNCER_DB_USER:-postgres} password=${PGBOUNCER_DB_PASSWORD}

[pgbouncer]
listen_addr = ${PGBOUNCER_LISTEN_ADDR:-0.0.0.0}
listen_port = ${PGBOUNCER_LISTEN_PORT:-6432}
auth_type = ${PGBOUNCER_AUTH_TYPE:-md5}
auth_file = ${PGBOUNCER_AUTH_FILE:-/etc/pgbouncer/userlist.txt}
auth_query = ${PGBOUNCER_AUTH_QUERY:-}
pool_mode = ${PGBOUNCER_POOL_MODE:-session}
server_reset_query = ${PGBOUNCER_SERVER_RESET_QUERY:-DISCARD ALL}
max_client_conn = ${PGBOUNCER_MAX_CLIENT_CONN:-100}
default_pool_size = ${PGBOUNCER_DEFAULT_POOL_SIZE:-20}
min_pool_size = ${PGBOUNCER_MIN_POOL_SIZE:-0}
reserve_pool_size = ${PGBOUNCER_RESERVE_POOL_SIZE:-0}
reserve_pool_timeout = ${PGBOUNCER_RESERVE_POOL_TIMEOUT:-5}
max_db_connections = ${PGBOUNCER_MAX_DB_CONNECTIONS:-0}
max_user_connections = ${PGBOUNCER_MAX_USER_CONNECTIONS:-0}
server_round_robin = ${PGBOUNCER_SERVER_ROUND_ROBIN:-0}
ignore_startup_parameters = ${PGBOUNCER_IGNORE_STARTUP_PARAMETERS:-extra_float_digits}
disable_pqexec = ${PGBOUNCER_DISABLE_PQEXEC:-0}
application_name_add_host = ${PGBOUNCER_APPLICATION_NAME_ADD_HOST:-0}

# Logging
log_connections = ${PGBOUNCER_LOG_CONNECTIONS:-1}
log_disconnections = ${PGBOUNCER_LOG_DISCONNECTIONS:-1}
log_pooler_errors = ${PGBOUNCER_LOG_POOLER_ERRORS:-1}
logfile = ${PGBOUNCER_LOGFILE:-/var/log/pgbouncer/pgbouncer.log}
pidfile = ${PGBOUNCER_PIDFILE:-/var/run/pgbouncer/pgbouncer.pid}

# Timeouts
server_lifetime = ${PGBOUNCER_SERVER_LIFETIME:-3600}
server_idle_timeout = ${PGBOUNCER_SERVER_IDLE_TIMEOUT:-600}
server_connect_timeout = ${PGBOUNCER_SERVER_CONNECT_TIMEOUT:-15}
server_login_retry = ${PGBOUNCER_SERVER_LOGIN_RETRY:-15}
query_timeout = ${PGBOUNCER_QUERY_TIMEOUT:-0}
query_wait_timeout = ${PGBOUNCER_QUERY_WAIT_TIMEOUT:-120}
client_idle_timeout = ${PGBOUNCER_CLIENT_IDLE_TIMEOUT:-0}
client_login_timeout = ${PGBOUNCER_CLIENT_LOGIN_TIMEOUT:-60}
autodb_idle_timeout = ${PGBOUNCER_AUTODB_IDLE_TIMEOUT:-3600}

# DNS settings
dns_nxdomain_ttl = ${PGBOUNCER_DNS_NXDOMAIN_TTL:-15}
dns_zone_check_period = ${PGBOUNCER_DNS_ZONE_CHECK_PERIOD:-0}
dns_max_ttl = ${PGBOUNCER_DNS_MAX_TTL:-15}

# TLS settings
client_tls_cert_file = ${PGBOUNCER_TLS_CERT_FILE:-}
client_tls_key_file = ${PGBOUNCER_TLS_KEY_FILE:-}
client_tls_ca_file = ${PGBOUNCER_TLS_CA_FILE:-}
client_tls_protocols = ${PGBOUNCER_TLS_PROTOCOLS:-secure}
client_tls_ciphers = ${PGBOUNCER_TLS_CIPHERS:-fast}
client_tls_ecdhcurve = ${PGBOUNCER_TLS_ECDHCURVE:-auto}
client_tls_dheparams = ${PGBOUNCER_TLS_DHEPARAMS:-auto}
EOF

# Generate userlist.txt if PGBOUNCER_USERLIST is provided
if [ -n "${PGBOUNCER_USERLIST:-}" ]; then
    echo "${PGBOUNCER_USERLIST}" > /etc/pgbouncer/userlist.txt
elif [ "${PGBOUNCER_AUTH_TYPE:-md5}" = "trust" ] && [ -n "${PGBOUNCER_DB_USER:-}" ]; then
    # Generate userlist with just username for trust auth
    echo "\"${PGBOUNCER_DB_USER}\" \"\"" > /etc/pgbouncer/userlist.txt
elif [ -n "${PGBOUNCER_DB_USER:-}" ] && [ -n "${PGBOUNCER_DB_PASSWORD:-}" ]; then
    # Generate userlist from database credentials
    echo "\"${PGBOUNCER_DB_USER}\" \"md5$(echo -n "${PGBOUNCER_DB_PASSWORD}${PGBOUNCER_DB_USER}" | md5sum | cut -d' ' -f1)\"" > /etc/pgbouncer/userlist.txt
fi

# Set proper permissions on config and userlist
chmod 600 /etc/pgbouncer/pgbouncer.ini
if [ -f /etc/pgbouncer/userlist.txt ]; then
    chmod 600 /etc/pgbouncer/userlist.txt
fi

# Start pgbouncer
exec pgbouncer /etc/pgbouncer/pgbouncer.ini
