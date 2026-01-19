#!/bin/bash

set -e

cd /var/www/html

echo "Waiting for MariaDB..."
until mysql -h"$WORDPRESS_DB_HOST" \
    -u"$WORDPRESS_DB_USER" \
    -p"$WORDPRESS_DB_PASSWORD" \
    "$WORDPRESS_DB_NAME" >/dev/null 2>&1; do
    sleep 2
done
echo "MariaDB is ready"

if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
fi

if [ ! -f wp-config.php ]; then
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root
fi

if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url="$WORDPRESS_URL" \
        --title="$WORDPRESS_SITE_TITLE" \
        --admin_user="$WORDPRESS_ADMIN_USER" \
        --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
        --admin_email="$WORDPRESS_ADMIN_EMAIL" \
        --skip-email \
        --allow-root
fi

chown -R www-data:www-data /var/www/html

exec php-fpm8.2 -F
