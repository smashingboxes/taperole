VAGRANTFILE_API_VERSION = "2"

Vagrant.configure("2") do |config|
  config.vm.box       = "precise64"
  config.vm.box_url   = "http://files.vagrantup.com/precise64.box"
  config.vm.host_name = "smashing-boxer-test-env"

  private_ip = "192.168.13.37"
  config.vm.network(:private_network, :ip => private_ip)
end
