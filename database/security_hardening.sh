#!/bin/bash

# MySQL Security Hardening Script

# Disable Remote Root Login
mysql -u root -p -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

# Remove Anonymous Users
mysql -u root -p -e "DELETE FROM mysql.user WHERE User='';"

# Disable MySQL X Protocol
echo "mysqlx=0" >> /etc/my.cnf

# Set Strong Password Policy
mysql -u root -p -e "
SET GLOBAL validate_password.policy=STRONG;
SET GLOBAL validate_password.length=12;
SET GLOBAL validate_password.mixed_case_count=1;
SET GLOBAL validate_password.number_count=1;
SET GLOBAL validate_password.special_char_count=1;
"

# Disable Local Infile for Security
echo "local-infile=0" >> /etc/my.cnf

# Set Maximum Connection Limit
echo "max_connections=100" >> /etc/my.cnf

# Secure Temporary Directory
chmod 750 /var/lib/mysql-files/

# Restart MySQL Service
systemctl restart mysqld