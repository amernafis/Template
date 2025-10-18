# Stage 1: Build PHP dependencies
FROM php:8.2-fpm AS build

WORKDIR /app

# Install required system packages and PHP extensions
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring zip bcmath

# Copy Composer binary
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy composer files and install dependencies (cached)
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

# Copy app source code
COPY . .

# Stage 2: Node build for assets
FROM node:20-alpine AS nodebuild
WORKDIR /app
COPY --from=build /app ./
RUN npm ci && npm run build

# Stage 3: Production runtime
FROM php:8.2-fpm-alpine AS production

WORKDIR /var/www/html

# Install necessary PHP extensions for runtime
RUN apk add --no-cache \
      libzip-dev \
      libpng-dev \
      oniguruma-dev \
    && docker-php-ext-install pdo_mysql mbstring zip bcmath

# Copy built app + assets
COPY --from=build /app ./
COPY --from=nodebuild /app/public/build ./public/build

# Set permissions for Laravel storage & cache
RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]

