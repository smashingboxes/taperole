Vagrant.configure("2") do |config|
  config.vm.box       = "precise64"
  config.vm.box_url   = "http://files.vagrantup.com/precise64.box"

  config.ssh.username = 'root'
  config.ssh.insert_key = 'true'

  private_ip = "192.168.13.37"
  config.vm.network(:private_network, :ip => private_ip)

  config.vm.define 'smashing_boxer_test' do |test|
    test.vm.box = 'smashing_boxer_test'
  end
end
