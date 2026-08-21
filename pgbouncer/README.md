# PgBouncer Docker Image

A secure Docker image for PgBouncer.

## Features

- 🐧 **Alpine Linux base** - Minimal, secure, and lightweight
- 🔒 **Security hardened** - Non-root user, minimal attack surface
- ⚙️ **Environment-driven configuration** - No config files needed
- 🚀 **Multi-architecture support** - AMD64 and ARM64
- 🔄 **Automated builds** - GitHub Actions with security scanning
- 📊 **Health checks** - Built-in health monitoring
- 🏷️ **Version tagging** - Docker tags match PgBouncer versions

## Quick Start

### Basic Usage

```bash
docker run -d \
  --name pgbouncer \
  -e PGBOUNCER_DB_HOST=postgres.example.com \
  -e PGBOUNCER_DB_PORT=5432 \
  -e PGBOUNCER_DB_NAME=mydatabase \
  -e PGBOUNCER_DB_USER=myuser \
  -e PGBOUNCER_DB_PASSWORD=mypassword \
  -p 6432:6432 \
  ghcr.io/starttoaster/pgbouncer:latest
```

### With Docker Compose

```yaml
version: '3.8'
services:
  pgbouncer:
    image: ghcr.io/starttoaster/pgbouncer:latest
    environment:
      PGBOUNCER_DB_HOST: postgres.example.com
      PGBOUNCER_DB_PORT: 5432
      PGBOUNCER_DB_NAME: mydatabase
      PGBOUNCER_DB_USER: myuser
      PGBOUNCER_DB_PASSWORD: mypassword
    ports:
      - "6432:6432"
    depends_on:
      - postgres
```

## Configuration

All configuration is done through environment variables. See [Environment Variables](examples/environment-variables.md) for a complete list.

### Essential Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PGBOUNCER_DB_HOST` | `localhost` | PostgreSQL server hostname |
| `PGBOUNCER_DB_PORT` | `5432` | PostgreSQL server port |
| `PGBOUNCER_DB_NAME` | `postgres` | Default database name |
| `PGBOUNCER_DB_USER` | `postgres` | Database username |
| `PGBOUNCER_DB_PASSWORD` | (empty) | Database password |

### Pooling Modes

- **session** (default): One server connection per client connection
- **transaction**: One server connection per transaction
- **statement**: One server connection per statement (most aggressive)

## Examples

### Production Configuration

```bash
docker run -d \
  --name pgbouncer \
  --restart unless-stopped \
  -e PGBOUNCER_DB_HOST=postgres-cluster.internal \
  -e PGBOUNCER_DB_PORT=5432 \
  -e PGBOUNCER_DB_NAME=myapp \
  -e PGBOUNCER_DB_USER=app_user \
  -e PGBOUNCER_DB_PASSWORD=secure_password \
  -e PGBOUNCER_POOL_MODE=transaction \
  -e PGBOUNCER_MAX_CLIENT_CONN=500 \
  -e PGBOUNCER_DEFAULT_POOL_SIZE=50 \
  -e PGBOUNCER_MIN_POOL_SIZE=10 \
  -e PGBOUNCER_RESERVE_POOL_SIZE=10 \
  -e PGBOUNCER_SERVER_LIFETIME=3600 \
  -e PGBOUNCER_SERVER_IDLE_TIMEOUT=600 \
  -e PGBOUNCER_LOG_CONNECTIONS=1 \
  -e PGBOUNCER_LOG_DISCONNECTIONS=1 \
  -p 6432:6432 \
  ghcr.io/starttoaster/pgbouncer:latest
```

### TLS Configuration

```bash
docker run -d \
  --name pgbouncer \
  -e PGBOUNCER_DB_HOST=postgres.example.com \
  -e PGBOUNCER_DB_USER=myuser \
  -e PGBOUNCER_DB_PASSWORD=mypassword \
  -e PGBOUNCER_TLS_CERT_FILE=/etc/ssl/certs/server.crt \
  -e PGBOUNCER_TLS_KEY_FILE=/etc/ssl/private/server.key \
  -e PGBOUNCER_TLS_CA_FILE=/etc/ssl/certs/ca.crt \
  -v /path/to/certs:/etc/ssl/certs:ro \
  -v /path/to/private:/etc/ssl/private:ro \
  -p 6432:6432 \
  ghcr.io/starttoaster/pgbouncer:latest
```

### Kubernetes Deployment

See [kubernetes-deployment.yaml](examples/kubernetes-deployment.yaml) for a complete Kubernetes example.

## Versioning

Docker image tags correspond to PgBouncer versions:

- `latest` - Latest stable version
- `1.24.0` - Specific PgBouncer version
