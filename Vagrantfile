Vagrant.configure("2") do |config|
  config.vm.box       = "precise64"
  config.vm.box_url   = "http://files.vagrantup.com/precise64.box"

  private_ip = "192.168.13.37"
  config.vm.network(:private_network, :ip => private_ip)
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  config.vm.provision :shell, path: "#{ENV['SMASHING_BOXER_PATH']}/vagrant-bootstrap.sh"

  name = %x[basename `git rev-parse --show-toplevel`].chomp
  config.vm.define "#{name}_vagrant_box" do |test|
    test.vm.box = "#{name}_vagrant_box"
  end
end
