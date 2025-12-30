#!/bin/bash

set -e

# Create required vsftpd directory
mkdir -p /var/run/vsftpd/empty

# Create FTP user
useradd -m ftpuser
echo "ftpuser:ftppassword" | chpasswd

# Ensure WordPress files are owned by ftpuser
chown -R ftpuser:ftpuser /var/www/html

# Start vsftpd in foreground
exec vsftpd /etc/vsftpd.conf
