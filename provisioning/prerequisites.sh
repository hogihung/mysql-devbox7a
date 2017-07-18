# Update our fresh install
yum update -y

# Install basic tools
yum install -y wget tree unzip expect dos2unix nc

# Install Vim Editor
yum install -y vim-X11 vim-common vim-enhanced vim-minimal

# Install Node
curl -sL https://rpm.nodesource.com/setup_7.x | bash -
yum install -y nodejs

