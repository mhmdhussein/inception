FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Install nginx and openssl
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Remove default site
RUN rm -f /etc/nginx/sites-enabled/default

# Copy nginx configs
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# Copy SSL generation script
COPY tools/generate_ssl.sh /usr/local/bin/generate_ssl.sh
RUN chmod +x /usr/local/bin/generate_ssl.sh

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Expose HTTPS only
EXPOSE 443

# Generate certs and start nginx
ENTRYPOINT ["/usr/local/bin/generate_ssl.sh"]
