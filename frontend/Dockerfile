FROM node:22-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM nginx:1.27-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/dist /usr/share/nginx/html

RUN sed -i 's#pid[[:space:]]*/run/nginx.pid;#pid /tmp/nginx.pid;#' /etc/nginx/nginx.conf && sed -i '/^[[:space:]]*user[[:space:]]/d' /etc/nginx/nginx.conf && mkdir -p /tmp/nginx /var/cache/nginx/client_temp /var/cache/nginx/proxy_temp /var/cache/nginx/fastcgi_temp /var/cache/nginx/uwsgi_temp /var/cache/nginx/scgi_temp /var/log/nginx && chown -R nginx:nginx /tmp/nginx /var/cache/nginx /var/log/nginx /usr/share/nginx/html

EXPOSE 8080

USER nginx

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
