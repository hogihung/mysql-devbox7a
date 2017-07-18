# Install prerequisites in order to build more current Git
yum install -y curl-devel expat-devel gettext-devel openssl-devel zlib-devel gcc perl-ExtUtils perl-devel

# Install Git
cd /usr/src
wget https://www.kernel.org/pub/software/scm/git/git-2.11.1.tar.gz
tar xzf git-2.11.1.tar.gz
cd git-2.11.1
make prefix=/usr/local/git all
make prefix=/usr/local/git install

# Add Git to the patch
echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/bashrc
