# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure 2 do |config|
  config.vm.box = 'hashicorp/precise64'

  name = %x[basename `git rev-parse --show-toplevel`].chomp
  config.vm.define "#{name}_vagrant_box"

  private_ip = "192.168.13.37"
  config.vm.network(:private_network, :ip => private_ip)

  config.ssh.insert_key = false
  config.ssh.shell = 'bash -c "BASH_ENV=/etc/profile exec bash"'

  config.vm.provision :shell, inline: <<-SCRIPT
    sudo su
    mkdir ~/.ssh/
    cp /home/vagrant/.ssh/authorized_keys ~/.ssh/
    chmod 600 ~/.ssh/authorized_keys
  SCRIPT
end
