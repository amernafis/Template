# Stage 1: Composer dependencies
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

# Stage 2: Node build
FROM node:20 AS frontend
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Stage 3: Runtime
FROM php:8.2-fpm-alpine
WORKDIR /var/www/html

RUN apk add --no-cache bash libpng-dev libjpeg-turbo-dev libzip-dev oniguruma-dev icu-dev libxml2-dev zip unzip \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd intl zip

COPY . .
COPY --from=vendor /app/vendor ./vendor
COPY --from=frontend /app/public/build ./public/build

RUN addgroup -g 1000 laravel && adduser -G laravel -u 1000 -D laravel && chown -R laravel:laravel /var/www/html
USER laravel

EXPOSE 9000
CMD ["php-fpm"]
