#!/bin/bash

# Grab the temporary password for root created during the install
ROOT_PASS=$(cat /var/log/mysqld.log | grep 'A temporary password is generated for root@localhost:' | awk '{print $11}')

# Configure new password for root user
NEW_PASS='Ph0en!x7'

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter password for user root:\"
send \"$ROOT_PASS\r\"
expect \"New password:\"
send \"${NEW_PASS}\r\"
expect \"Re-enter new password:\"
send  \"${NEW_PASS}\r\"
expect \"Change the password for root ?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

