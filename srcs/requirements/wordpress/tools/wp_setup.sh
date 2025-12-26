#!/bin/bash

set -e

# Wait for MariaDB
until mysqladmin ping -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

# Download WordPress if not present
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Downloading WordPress..."

    wget https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz --strip-components=1
    rm latest.tar.gz

    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" wp-config.php
    sed -i "s/username_here/${WORDPRESS_DB_USER}/" wp-config.php
    sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" wp-config.php
    sed -i "s/localhost/${WORDPRESS_DB_HOST}/" wp-config.php

    chown -R www-data:www-data /var/www/html
fi

# Install WordPress using WP-CLI style logic
if ! wp core is-installed --allow-root 2>/dev/null; then
    php -r "
    define('WP_INSTALLING', true);
    require 'wp-admin/includes/upgrade.php';
    wp_install(
        getenv('WORDPRESS_SITE_TITLE'),
        getenv('WORDPRESS_ADMIN_USER'),
        getenv('WORDPRESS_ADMIN_PASSWORD'),
        getenv('WORDPRESS_ADMIN_EMAIL')
    );
    "
fi

# Start PHP-FPM in foreground (PID 1)
exec php-fpm8.2 -F
