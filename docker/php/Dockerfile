# syntax=docker/dockerfile:1

# PHP version is set here only (ADR 0004). Upgrade: change, rebuild, run the tests.
ARG PHP_VERSION=8.4

# NTS base: php-fpm (and later Swoole, RoadRunner).
FROM php:${PHP_VERSION}-fpm-trixie AS base-nts

RUN apt-get update \
    && apt-get install -y --no-install-recommends libicu-dev libpq-dev libzip-dev unzip \
    && docker-php-ext-install -j"$(nproc)" bcmath intl opcache pcntl pdo_pgsql zip \
    && rm -rf /var/lib/apt/lists/*

COPY docker/php/php.ini $PHP_INI_DIR/conf.d/50-app.ini
COPY docker/php/fpm.conf /usr/local/etc/php-fpm.d/zz-app.conf

WORKDIR /var/www/html

# php-fpm, development: code is mounted from the host.
FROM base-nts AS fpm-dev

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && pecl install xdebug-3.5.3 \
    && docker-php-ext-enable xdebug

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY docker/php/php-dev.ini $PHP_INI_DIR/conf.d/60-dev.ini

# php-fpm, production: code and dependencies in the image, no Composer.
FROM base-nts AS fpm-prod

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY docker/php/opcache.ini $PHP_INI_DIR/conf.d/60-opcache.ini

COPY composer.json composer.lock ./
RUN --mount=type=bind,from=composer:2,source=/usr/bin/composer,target=/usr/bin/composer \
    composer install --no-dev --no-scripts --no-autoloader --prefer-dist --no-interaction

COPY . .
RUN --mount=type=bind,from=composer:2,source=/usr/bin/composer,target=/usr/bin/composer \
    composer dump-autoload --no-dev --classmap-authoritative --no-interaction \
    && chown -R www-data:www-data storage bootstrap/cache
