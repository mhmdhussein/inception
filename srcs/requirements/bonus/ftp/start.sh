#!/bin/bash

set -e

# Create FTP user
useradd -m ftpuser
echo "ftpuser:ftppassword" | chpasswd

# Set ownership to WordPress files
chown -R ftpuser:ftpuser /var/www/html

# Start vsftpd in foreground
exec vsftpd /etc/vsftpd.conf
