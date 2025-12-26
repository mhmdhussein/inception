FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Install PHP, PHP-FPM and required extensions
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-intl \
    php-mbstring \
    php-soap \
    php-xml \
    php-xmlrpc \
    php-zip \
    wget \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create WordPress directory
RUN mkdir -p /var/www/html

# Copy PHP-FPM pool config
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copy WordPress setup script
COPY tools/wp_setup.sh /usr/local/bin/wp_setup.sh
RUN chmod +x /usr/local/bin/wp_setup.sh

# Expose PHP-FPM port
EXPOSE 9000

# Set working directory
WORKDIR /var/www/html

# Start WordPress setup + PHP-FPM
ENTRYPOINT ["/usr/local/bin/wp_setup.sh"]
