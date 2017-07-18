echo "Adding related hosts to /etc/hosts file"
echo "192.168.70.10     devbox7-a.localdomain      devbox7-a" >> /etc/hosts
echo "192.168.70.11     devbox7-b.localdomain      devbox7-b" >> /etc/hosts

echo "Copy over the MOTD Banner."
mv /home/vagrant/Downloads/motd /etc/motd
chown root:root /etc/motd

# Fix issue with ssh/scp between Vagrant VMs and Host Operating System
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config;
systemctl restart sshd;

# MAY NEED TO MOVE THE ABOVE 
# Copy over prefilled /etc/my.cnf file for mysql
cp /home/vagrant/Downloads/my.cnf /etc/my.cnf

# Restart MySQL Server
systemctl restart mysqld
