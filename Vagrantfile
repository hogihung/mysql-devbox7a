# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"

  config.vm.hostname = 'devbox7-a'

  config.vm.network :private_network, ip: "192.168.70.10"
  config.vm.network :forwarded_port, guest: 22, host: 2210, id: "ssh"
  config.vm.network :forwarded_port, guest: 4000, host: 9010, id: "phoenix"
  config.vm.network :forwarded_port, guest: 3306, host: 9310, id: "mysqldb"

  # Adjust this to meet your configuration needs
  config.vm.synced_folder "/Users/jfhogarty/Documents/Programming/Elixir/DEVBOX7A-B", "/vagrant"

  config.vm.provider :virtualbox do |vb|
    host = RbConfig::CONFIG['host_os']
    # Give VM 1/4 system memory 
    if host =~ /darwin/
      # sysctl returns Bytes and we need to convert to MB
      mem = `sysctl -n hw.memsize`.to_i / 1024
    elsif host =~ /linux/
      # meminfo shows KB and we need to convert to MB
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i 
    elsif host =~ /mswin|mingw|cygwin/
      # Windows code via https://github.com/rdsubhas/vagrant-faster
      mem = `wmic computersystem Get TotalPhysicalMemory`.split[1].to_i / 1024
    end
 
    mem = mem / 1024 / 4
    vb.memory = ENV['VAGRANT_MEMORY'] || mem

    vb.customize ["modifyvm", :id, "--name", "devbox7-a"]
  end

  # ---------------------------------------------------------------------------
  # Copy any required files to the VM during initial provisioning:
  # ---------------------------------------------------------------------------
  config.vm.provision "file", source: "files/home/vagrant/Downloads/motd", destination: "/home/vagrant/Downloads/motd"
  config.vm.provision "file", source: "files/home/vagrant/Downloads/my.cnf", destination: "/home/vagrant/Downloads/my.cnf"

  # ---------------------------------------------------------------------------
  # Execute provisioning script(s):
  # ---------------------------------------------------------------------------
  config.vm.provision "shell", path: "provisioning/prerequisites.sh", privileged: true
  config.vm.provision "shell", path: "provisioning/install_git.sh", privileged: true
  config.vm.provision "shell", path: "provisioning/install_elixir.sh", privileged: true
  config.vm.provision "shell", path: "provisioning/install_mysql.sh", privileged: true
  config.vm.provision "shell", path: "provisioning/install_phoenix.sh", privileged: false
  config.vm.provision "shell", path: "provisioning/install_rvm_ruby.sh", privileged: false
  config.vm.provision "shell", path: "provisioning/post_install.sh", privileged: true
  config.vm.provision "shell", path: "provisioning/set_mysql_root_pw.sh", privileged: true

end
