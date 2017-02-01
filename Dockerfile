FROM php:7.0.14-fpm
MAINTAINER miron.ogrodowicz@kreativrudel.de

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
        libjpeg-dev \
        libpng12-dev \
        libssl-dev \
        libicu-dev \
        libfreetype6-dev \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /usr/include/freetype2/freetype; \
    ln -s /usr/include/freetype2/freetype.h /usr/include/freetype2/freetype/freetype.h; \
    \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir=/usr/include/freetype2/freetype; \
    docker-php-ext-install gd mysqli opcache; \
    \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    \
    pecl install phar; \
    docker-php-ext-install phar; \
    \
    pecl install intl; \
    docker-php-ext-install intl

EXPOSE 9000
