module Taperole
  module AnsibleRunner
    include Taperole::Helpers::Files

    protected

    def valid_preconfigs
      if rails_app?
        valid_gems
      elsif fe_app?
        true
      else
        false
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

    def ansible_custom_playbook(cmd_str = '')
      exec_ansible("#{tapefiles_dir}/#{opts.book}", cmd_str)
    end

    def ansible_rake_task
      exec_ansible("#{tapefiles_dir}/rake.yml", "--extra-vars \"task=#{opts.task}\"")
    end

    def exec_ansible(playbook, args)
      enforce_roles_path!
      cmd = "ANSIBLE_CONFIG=#{local_dir}/.tape/ansible.cfg ansible-playbook -i #{inventory_file} #{playbook} #{args} #{hosts_flag} -e tape_dir=#{tape_dir}"
      cmd += ' --ask-vault-pass' if opts.vault
      cmd += ' -vvvv' if opts.verbose
      cmd += " -t #{opts.tags}" if opts.tags
      STDERR.puts "Executing: #{cmd}" if opts.verbose
      notify_observers(:start)
      if Kernel.system(cmd)
        notify_observers(:success)
      else
        notify_observers(:fail)
      end
    end

    def enforce_roles_path!
      Dir.mkdir('.tape') unless Dir.exists?('.tape')

      File.open("#{local_dir}/.tape/ansible.cfg", 'w') do |f|
        f.puts '[defaults]'
        f.puts "roles_path=.tape/roles:#{tape_dir}/roles:#{tape_dir}/vendor"
        f.puts "inventory=#{tapefiles_dir}/hosts"
        f.puts "retries-dir=/dev/null"
        f.puts "retry_files_enabled = False"
        f.puts '[ssh_connection]'
        f.puts 'ssh_args=-o ForwardAgent=yes'
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
