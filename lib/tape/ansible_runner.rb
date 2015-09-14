# Executes ansible commands
module TapeBoxer
class AnsibleRunner < ExecutionModule
  TapeBoxer.register_module :ansible, self

  action :configure_dj_runner,
    proc {ansible '-t configure_dj_runner -e force_dj_runner_restart=true'},
    "Configures and restarts the delayed job runner"
  action :restart_unicorn,
    proc {ansible '-t unicorn_restart'}, 
    "Restarts the unicorns running on the app servers"
  action :stop_unicorn,
    proc {ansible '-t unicorn_stop -e kill_unicorn=true'}, 
    "Stops the unicorns running on the app servers"
  action :force_stop_unicorn,
    proc {ansible '-t unicorn_force_stop -e kill_unicorn=true'}, 
    "Stops the unicorns running on the app servers"
  action :start_unicorn,
    proc {ansible '-t unicorn_start'},
    "Starts the unicorns running on the app servers"
  action :restart_nginx,
    proc {ansible '-t restart_nginx'},
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
  action :be_deploy,
    proc {ansible_deploy '-t be_deploy'},
    "Re-deploys fe code"
  action :fe_deploy,
    proc {ansible_deploy '-t fe_deploy'},
    "Re-deploys fe code"
  action :deploy,
    proc {ansible_deploy '-t be_deploy,fe_deploy'},
    "Checks out app code, installs dependencies and restarts unicorns for "\
    "both FE and BE code."
  action :everything,
    proc { ansible if valid_preconfigs },
    "This does it all."

  def initialize(*args)
    super
  end

  protected
  attr_reader :opts

  def valid_preconfigs
    if rails_app?
      return valid_gems
    end
  end

  def valid_gems
    has_gem_in_gemfile('unicorn')
  end

  def has_gem_in_gemfile(name)
    if open('Gemfile').grep(/#{name}/).empty?
      puts "💥 ERROR: Add #{name} to your Gemfile!💥 ".red
      false
    else
      true
    end
  end

  def ansible(cmd_str = '')
    exec_ansible("#{tapefiles_dir}/omnibox.yml", cmd_str)
  end

  def ansible_deploy(cmd_str = '')
    exec_ansible("#{tapefiles_dir}/deploy.yml", cmd_str)
  end

  def exec_ansible(playbook, args)
    enforce_roles_path!
    cmd = "ANSIBLE_CONFIG=#{local_dir}/.tape/ansible.cfg ansible-playbook -i #{inventory_file} #{playbook} #{args} #{hosts_flag} -e tape_dir=#{tape_dir}"
    cmd += ' -vvvv' if opts.verbose
    cmd += " -t #{opts.tags}" if opts.tags
    STDERR.puts "Executing: #{cmd}" if opts.verbose
    Kernel.exec(cmd)
  end

  def enforce_roles_path!
    Dir.mkdir('.tape') unless Dir.exists?('.tape')
    File.open("#{local_dir}/.tape/ansible.cfg", 'w') do |f|
      f.puts '[defaults]'
      f.puts "roles_path=.tape/roles:#{tape_dir}/roles:#{tape_dir}/vendor"
      f.puts "inventory=#{tapefiles_dir}/hosts"
      f.puts "retries-dir=/dev/null"
      f.puts '[ssh_connection]'
      f.puts 'ssh_args = -o ForwardAgent=yes'
    end
  end

  def hosts_flag
    "-l #{opts.host_pattern}" if opts.host_pattern
  end

  def inventory_file
    opts.inventory_file || "#{tapefiles_dir}/hosts"
  end
end
end
