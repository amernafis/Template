FROM php:8.3-fpm

# --- System dependencies ---
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd sockets && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# --- Install Composer ---
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# --- Node.js for npm build (optional) ---
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# --- Copy Laravel app ---
WORKDIR /var/www
COPY . .

# --- Install dependencies ---
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build || true

# --- Nginx config ---
COPY docker/nginx/default.conf /etc/nginx/conf.d/default.conf

# --- PHP config ---
COPY docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini

# --- Supervisor config (to run both Nginx + PHP-FPM) ---
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# --- Permissions ---
RUN chown -R www-data:www-data /var/www

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
