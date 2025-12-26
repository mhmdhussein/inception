#!/bin/bash

set -e

SSL_DIR="/etc/nginx/ssl"

if [ ! -f "${SSL_DIR}/inception.crt" ]; then
    echo "Generating self-signed SSL certificate..."

    openssl req -x509 -nodes -days 365 \
        -newkey rsa:2048 \
        -keyout ${SSL_DIR}/inception.key \
        -out ${SSL_DIR}/inception.crt \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=Inception/CN=${DOMAIN_NAME}"
fi

# Start nginx in foreground (PID 1)
exec nginx -g "daemon off;"
