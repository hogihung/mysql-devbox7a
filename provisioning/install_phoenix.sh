# Update path so Elixir is available for this session
export PATH=/usr/local/bin:$PATH

# Add path for supporting Elixir to Vagrant users bash profile
echo "export PATH=/usr/local/bin:$PATH" >> /home/vagrant/.bash_profile

# Install Hex
mix local.hex --force

# Install Phoenix
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force
mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez --force

