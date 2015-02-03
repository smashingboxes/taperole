# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty64'

  config.vm.provision :ansible do |ansible|
    ansible.playbook = 'site.yml'
    ansible.extra_vars = {
      npm_packages: [
        {name: 'coffee-script'},
        {name: 'bower'}
      ]
    }
  end
end
