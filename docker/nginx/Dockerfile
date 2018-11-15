FROM nginx:alpine

RUN \
  ln -sf /dev/stdout /var/log/nginx/access.log          &&  \
  ln -sf /dev/stderr /var/log/nginx/error.log

COPY ./nginx-config /etc/nginx
