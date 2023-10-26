FROM nginx:latest

RUN mkdir -p /etc/nginx/nginx_configs \
    && mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

COPY nginx_configs/security /etc/nginx/nginx_configs/security
COPY nginx_configs/includes /etc/nginx/nginx_configs/includes
COPY security/automatticips.inc /etc/nginx/nginx_configs/security/automatticips.inc
COPY nginx.conf /etc/nginx/nginx.conf
