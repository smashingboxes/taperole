# Executes ansible commands
module TapeBoxer
class AnsibleRunner < ExecutionModule
  TapeBoxer.register_module :ansible, self

  action :configure_dj_runner,
    proc {ansible '-t configure_dj_runner -e force_dj_runner_restart=true'},
    "Configures and restarts the delayed job runner"
  action :configure_unicorn,
    proc {ansible '-t configure_unicorn -e force_unicorn_restart=true'},
    "Configures and restarts the unicorn app server"
  action :reload_unicorn,
    proc {ansible '-t unicorn_reload -e force_unicorn_reload=true'},
    "Reloads the unicorns running on the app servers"
  action :restart_unicorn,
    proc {ansible '-t unicorn_restart -e force_unicorn_restart=true'}
    "Restarts the unicorns running on the app servers"
  action :restart_nginx,
    proc {ansible '-t restart_nginx'}
    "Restarts Nginx"
  action :configure_deployer_user,
    proc {ansible '-t deployer'},
    "Ensures the deployer user is present and configures his SSH keys"
  action :reset_db,
    proc {ansible '-t db_reset -e force_db_reset=true'},
    "wipes and re-seeds the DB"
  action :bundle,
    proc {ansible '-t bundle -e force_bundle=true'},
    "Bundles the gems running on the app servers"
  action :fe_deploy,
    proc {ansible '-t fe -e force_fe_build=true'},
    "Re-deploys fe code"
  action :deploy,
    proc {ansible_deploy},
    "Checks out app code, installs dependencies and restarts unicorns for "\
    "both FE and BE code."
  action :everything, proc {ansible}, "This does it all."

  def initialize(*args)
    ENV['ANSIBLE_CONFIG'] = File.join(sb_dir, 'ansible.cfg')
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
    cmd = "ansible-playbook -i #{inventory_file} #{playbook} #{args} #{hosts_flag}"
    cmd += ' -vvvv' if opts.verbose
    STDERR.puts "Executing: #{cmd}" if opts.verbose
    Kernel.exec(cmd)
  end

  def hosts_flag
    "-l #{opts.host_pattern}" if opts.host_pattern
  end

  def inventory_file
    opts.inventory_file || "#{local_dir}/hosts"
  end
end
end
