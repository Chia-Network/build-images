FROM php:8.2-fpm

RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libz-dev \
        less \
        imagemagick \
        libmagickwand-dev \
        default-mysql-client \
        libmemcached11 \
        libmemcachedutil2 \
        libmemcached-dev \
        libssl-dev \
        libzip-dev \
    && pecl install imagick memcached \
    && docker-php-ext-configure opcache --enable-opcache \
    && docker-php-ext-enable imagick memcached \
    && docker-php-ext-install \
        exif \
        gd \
        intl \
        mysqli \
        pdo_mysql \
        soap \
        sockets \
        zip \
    && apt-get remove -y build-essential libz-dev libmemcached-dev libssl-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && mkdir /var/www/.wp-cli \
    && chown www-data:www-data /var/www/.wp-cli

COPY zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY php.ini /usr/local/etc/php/conf.d/99-chia-php.ini
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini
