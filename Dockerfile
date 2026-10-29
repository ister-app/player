FROM nginxinc/nginx-unprivileged:1.31.6-alpine

# Upgrade the Alpine packages the base image ships with. nginx-unprivileged is
# only rebuilt now and then, and until it is, a fixed package in the Alpine
# repo does not reach this image. On 29-10-2026 even the newest tag,
# 1.31.7-alpine (built 19-10), still had brotli-libs 1.2.0-r1: CVE-2026-111497
# (critical, fix 1.2.1-r0 since 22-10). The base runs as nginx (101); apk needs
# root for the upgrade only.
USER root
RUN apk upgrade --no-cache
USER 101

LABEL org.opencontainers.image.source="https://github.com/ister-app/player"

# The entrypoint renders /etc/nginx/templates/*.template into /etc/nginx/conf.d/
# with envsubst. Restrict substitution to CROSS_ORIGIN_ISOLATION so nginx's own
# $uri-style variables in the template survive.
ENV CROSS_ORIGIN_ISOLATION=on
ENV NGINX_ENVSUBST_FILTER='^CROSS_ORIGIN_ISOLATION$'

COPY build/web /usr/share/nginx/html
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY nginx/snippets/ /etc/nginx/snippets/

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
