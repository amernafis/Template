# Use official PHP image with required extensions
FROM php:8.3-cli

# Set working directory
WORKDIR /var/www/html

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    zip unzip git curl libzip-dev libpng-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy project files
COPY . .

# Install dependencies
RUN composer install --no-interaction --no-scripts --no-progress

# Expose Laravel port
EXPOSE 8000

# Run Laravel dev server
CMD php artisan serve --host=0.0.0.0 --port=8000
