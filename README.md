# nginx-min

Минимальный Docker-образ с nginx (~8 МБ). Статический бинарь, базовый образ `scratch` — нет ОС, нет shell, нет лишних пакетов.

## Структура

```
.
├── Dockerfile        # Двухэтапная сборка: Alpine → scratch
├── nginx.conf        # Минимальный конфиг nginx
├── docker-compose.yml
└── html/
    └── index.html    # Статика
```

## Запуск

```bash
# Compose
docker compose up -d

# Или вручную
docker build -t nginx-min .
docker run -p 8080:80 nginx-min
```

Открыть: http://localhost:8080

## Сборка

Двухэтапная:

1. **builder** — Alpine компилирует nginx со статической линковкой (`-static`)
2. **scratch** — только бинарь + конфиг, без ОС

Отключённые модули: uwsgi, scgi, fastcgi, grpc, memcached, auth_basic, mail.  
Оставлены: http, ssl, proxy.

## Размер

| Образ | Размер |
|---|---|
| `nginx:latest` | ~190 МБ |
| `nginx:alpine` | ~25 МБ |
| **nginx-min** | **~8 МБ** |

## Конфигурация

Для смены порта или root-директории — редактировать `nginx.conf` и пересобрать.

```bash
docker build --build-arg NGINX_VERSION=1.26.2 -t nginx-min .
```
