FROM php:7.2.4-fpm
MAINTAINER miron.ogrodowicz@kreativrudel.de

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y \
        libjpeg-dev \
        libpng-dev \
        libssl-dev \
        libicu-dev \
        libfreetype6-dev \
        zlib1g-dev \
        libzip-dev \
        libmcrypt-dev \
    ; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /usr/include/freetype2/freetype; \
    \
    docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr --with-freetype-dir=/usr/include/freetype2/freetype; \
    docker-php-ext-install gd mysqli opcache; \
    \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    \
    docker-php-ext-install zip; \
    \
    docker-php-ext-install intl; \
    \
    docker-php-ext-install pdo_mysql; \
    \
    pecl install mcrypt-1.0.1 \
    docker-php-ext-enable mcrypt

RUN set -ex; \
    \
    cd /tmp; \
    curl -L -O https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64; \
    mv mhsendmail_linux_amd64 /usr/bin/mhsendmail; \
    chmod +x /usr/bin/mhsendmail; \
    echo 'sendmail_path = "/usr/bin/mhsendmail --smtp-addr=mailhog:1025"' > /usr/local/etc/php/conf.d/mailhog.ini

RUN set -ex; \
    \
    curl -L -s -O https://github.com/nicolas-van/multirun/releases/download/0.3.0/multirun-ubuntu-0.3.0.tar.gz; \
    tar zxvf multirun-ubuntu-0.3.0.tar.gz; \
    mv multirun /bin; \
    rm multirun-ubuntu-0.3.0.tar.gz

CMD ["multirun", "php-fpm", "socat TCP-LISTEN:8088,fork TCP:application:80"]

EXPOSE 9000
