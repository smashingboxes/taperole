# Executes ansible commands
module SmashingBoxer
class AnsibleRunner < ExecutionModule
  SmashingBoxer.register_module :ansible, self

  action :configure_dj_runner,
    proc {ansible '-t configure_dj_runner -e force_dj_runner_restart=true'},
    "Configures and restarts the delayed job runner"
  action :reload_unicorn,
    proc {ansible '-t unicorn_reload -e force_unicorn_reload'},
    "Reloads the unicorns running on the app servers"
  action :restart_unicorn,
    proc {ansible '-t unicorn_restart -e force_unicorn_restart=true'}
    "Restarts the unicorns running on the app servers"
  action :bundle,
    proc {ansible '-t bundle -e force_bundle=true'},
    "Bundles the gems running on the app servers"
  action :deploy,
    proc {ansible_deploy},
    "Checks out app code, installs dependencies and restarts unicorns for "\
    "both FE and BE code."
  action :everything, proc {ansible}, "This does it all."

  def initialize(*args)
    ENV['SMASHING_BOXER_PATH'] = File.join(__dir__, '../../')
    super
  end

  protected
  attr_reader :opts

  def ansible(cmd_str = '')
    exec_ansible('omnibox.yml', cmd_str)
  end

  def ansible_deploy
    exec_ansible('deploy.yml', '-t deploy')
  end

  def exec_ansible(playbook, args)
    playbook = File.join(sb_dir, playbook)
    cmd = "ansible-playbook -i #{inventory_file} #{playbook} #{args}"
    cmd += ' -vvvv' if opts.verbose
    STDERR.puts "Executing: #{cmd}" if opts.verbose
    Kernel.exec(cmd)
  end

  def inventory_file
    opts.inventory_file || 'test_hosts'
  end
end
end
