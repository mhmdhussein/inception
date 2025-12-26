FROM debian:bookworm

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install MariaDB
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Copy MariaDB config
COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy init script
COPY tools/init_db.sh /usr/local/bin/init_db.sh
RUN chmod +x /usr/local/bin/init_db.sh

# Create runtime directory
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Expose MariaDB port internally
EXPOSE 3306

# MariaDB data directory (used by volume)
VOLUME ["/var/lib/mysql"]

# Start MariaDB properly
ENTRYPOINT ["/usr/local/bin/init_db.sh"]
