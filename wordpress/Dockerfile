FROM alpine:latest
ARG WORDPRESS_VERSION
ENV WEBROOT=/var/www/html
ENV UID=33
ENV GID=33

RUN wget https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
    && tar -xvzf wordpress-${WORDPRESS_VERSION}.tar.gz \
    && rm -f wordpress-${WORDPRESS_VERSION}.tar.gz \
    && rm -rf /wordpress/wp-content

COPY copy.sh /copy.sh
RUN chmod +x /copy.sh

ENTRYPOINT ["/copy.sh"]
