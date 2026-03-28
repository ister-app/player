FROM nginxinc/nginx-unprivileged:alpine

LABEL org.opencontainers.image.source="https://github.com/ister-app/player"

COPY build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
