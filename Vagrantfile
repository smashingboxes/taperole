# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure 2 do |config|
  config.vm.box = "ubuntu/xenial64"

  name = %x[basename `git rev-parse --show-toplevel`].chomp.gsub(/[^0-9a-z ]/i, '')
  config.vm.define "#{name}_vagrant_box"
  config.vm.hostname = name

  private_ip = "192.168.13.37"
  config.vm.network(:private_network, ip: private_ip)

  config.vm.network 'forwarded_port', guest: 443, host: 8080
  config.vm.network 'private_network', type: 'dhcp'

  config.ssh.shell = 'bash -c "BASH_ENV=/etc/profile exec bash"'

  config.vm.provision :shell, inline: <<-SCRIPT
    sudo su
    mkdir -p ~/.ssh/
    cp /home/ubuntu/.ssh/authorized_keys ~/.ssh/
    chmod 600 ~/.ssh/authorized_keys
  SCRIPT
end
