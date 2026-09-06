FROM nginxinc/nginx-unprivileged:1.31.4-alpine

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
