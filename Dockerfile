FROM alpine:3.19 AS builder

ARG NGINX_VERSION=1.26.2

RUN apk add --no-cache \
    build-base \
    linux-headers \
    openssl-dev \
    openssl-libs-static \
    pcre-dev \
    zlib-dev \
    zlib-static \
    wget

RUN wget -q "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" \
    && echo "627fe086209bba80a2853a0add9d958d7ebbdffa1a8467a5784c9a6b4f03d738  nginx-${NGINX_VERSION}.tar.gz" | sha256sum -c - \
    && tar -xzf "nginx-${NGINX_VERSION}.tar.gz" \
    && cd "nginx-${NGINX_VERSION}" \
    && ./configure \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/dev/stderr \
        --http-log-path=/dev/stdout \
        --pid-path=/tmp/nginx.pid \
        --http-client-body-temp-path=/tmp/client_body \
        --http-proxy-temp-path=/tmp/proxy \
        --without-pcre2 \
        --with-ld-opt="-static" \
        --with-http_ssl_module \
        --without-http_uwsgi_module \
        --without-http_scgi_module \
        --without-http_fastcgi_module \
        --without-http_grpc_module \
        --without-http_memcached_module \
        --without-http_auth_basic_module \
        --without-mail_pop3_module \
        --without-mail_imap_module \
        --without-mail_smtp_module \
    && make -j$(nproc) \
    && make install \
    && mkdir -p /tmp/client_body /tmp/proxy \
    && echo "nobody:x:65534:65534:nobody:/:/sbin/nologin" > /etc_passwd \
    && echo "nobody:x:65534:" > /etc_group

FROM scratch
COPY --from=builder /usr/sbin/nginx /nginx
COPY --from=builder /etc/nginx /etc/nginx
COPY --from=builder /tmp /tmp
COPY --from=builder /etc_passwd /etc/passwd
COPY --from=builder /etc_group /etc/group
COPY nginx.conf /etc/nginx/nginx.conf
COPY html /etc/nginx/html

EXPOSE 80
ENTRYPOINT ["/nginx", "-g", "daemon off;"]
