# Install Erlang and Elixir
echo "Installing Erlang...................................................."
wget https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
yum install -y epel-release
yum install -y esl-erlang


# Build Elixir from source
echo "Installing Elixir...................................................."
cd /tmp
mkdir elixir
cd elixir
wget https://github.com/elixir-lang/elixir/archive/v1.4.5.tar.gz
gunzip v1.4.5.tar.gz
tar -xvf v1.4.5.tar
cd elixir-1.4.5/
make clean test
make install
rm -rf /tmp/elixir

