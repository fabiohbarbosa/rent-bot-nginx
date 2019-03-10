FROM nginx:alpine

COPY config/nginx.conf /etc/nginx/
COPY config/start.sh start.sh

EXPOSE 8080