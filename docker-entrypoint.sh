#!/bin/bash
set -e

mkdir -p /home/site/wwwroot/storage/framework/{cache,sessions,views} \
         /home/site/wwwroot/storage/app/public \
         /home/site/wwwroot/bootstrap/cache

chown -R www-data:www-data /home/site/wwwroot/storage /home/site/wwwroot/bootstrap/cache
chmod -R 775 /home/site/wwwroot/storage /home/site/wwwroot/bootstrap/cache

echo "Caching Laravel configuration..."
php artisan config:clear
php artisan route:clear
php artisan view:clear
php artisan cache:clear

php artisan config:cache
php artisan route:cache
php artisan view:cache

exec "$@"
