# Install MySQL Server 5.7 Community Edition
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
rpm -ivh mysql57-community-release-el7-11.noarch.rpm
yum install -y mysql-server
systemctl start mysqld

# Add log file which will be used with replication
mkdir /var/log/mysql
chmod -R 755 /var/log/mysql/
touch /var/log/mysql/mysql-bin.log
chown -R mysql:mysql /var/log/mysql/
