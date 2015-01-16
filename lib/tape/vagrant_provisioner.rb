module TapeBoxer
  class VagrantProvisioner < ExecutionModule
    TapeBoxer.register_module :vagrant, self

    action :create,
      proc {create_box}
      'Create a new vargant box with given name'
    action :start,
      proc {start_box},
      'Starts the vagrant box with given name'
    action :stop,
      proc {stop_box},
      'Stops the vagrant box with given name'
    action :ssh,
      proc {ssh_to_box},
      'Stops the vagrant box with given name'
    action :destroy,
      proc {destroy_box},
      'Stops the vagrant box with given name'

    protected
    def create_box
      Kernel.exec "vagrant up"
    end

    def stop_box
      Kernel.exec "vagrant halt #{opts[:name]}"
    end

    def start_box
      Kernel.exec "vagrant up #{opts[:name]}"
    end

    def ssh_to_box
      Kernel.exec "vagrant ssh #{opts[:name]}"
    end

    def destroy_box
      Kernel.exec "vagrant destroy #{opts[:name]}"
    end
  end
end
