# nginx-min

Minimal Docker image with nginx (~6.5 MB). Static, stripped binary on a `scratch` base — no OS, no shell, no extra packages.

## Structure

```
.
├── Dockerfile        # Two-stage build: Alpine → scratch
├── nginx.conf        # Minimal nginx config
├── docker-compose.yml
└── html/
    └── index.html    # Static site
```

## Usage

```bash
# Compose
docker compose up -d

# Manual
docker build -t nginx-min .
docker run -p 8080:80 nginx-min
```

Open: http://localhost:8080

## How it works

Two-stage build:

1. **builder** — Alpine compiles nginx with static linking (`-static`)
2. **scratch** — only the binary + config, no OS

Disabled modules: uwsgi, scgi, fastcgi, grpc, memcached, auth_basic, mail.  
Enabled: http, ssl, proxy.

## Size comparison

| Image | Size |
|---|---|
| `nginx:latest` | ~190 MB |
| `nginx:alpine` | ~25 MB |
| **nginx-min** | **~6.5 MB** |

## Configuration

To change port or root directory — edit `nginx.conf` and rebuild.

```bash
docker build --build-arg NGINX_VERSION=1.26.2 -t nginx-min .
```
