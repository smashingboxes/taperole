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
      has_gem_in_gemfile?('unicorn')
    end

    def has_gem_in_gemfile?(name)
      if open('Gemfile').grep(/#{name}/).empty?
        puts "💥 ERROR: Add #{name} to your Gemfile!💥 ".red
        false
      else
        true
      end
    end

    def ansible(args: '', options: {})
      exec_ansible("#{tapefiles_dir}/omnibox.yml", args, options)
    end

    def ansible_deploy(args: '', options: {})
      exec_ansible("#{tapefiles_dir}/deploy.yml", args, options)
    end

    def ansible_custom_playbook(args: '', options: {})
      exec_ansible("#{tapefiles_dir}/#{options[:book]}", args, options)
    end

    def ansible_rake_task(options: {})
      exec_ansible("#{tapefiles_dir}/rake.yml", "--extra-vars \"task=#{options[:task]}\"", options)
    end

    def exec_ansible(playbook, args, options)
      enforce_roles_path!
      cmd = "ANSIBLE_CONFIG=#{local_dir}/.tape/ansible.cfg ansible-playbook -i"
      cmd += " #{inventory_file(options)} #{playbook} #{args} #{hosts_flag(options)}"
      cmd += " -e tape_dir=#{tape_dir}"
      cmd += ' --ask-vault-pass' if options[:vault]
      cmd += ' -vvvv' if options[:verbose]
      cmd += " -t #{options[:tags]}" if options[:tags]
      STDERR.puts "Executing: #{cmd}" if options[:verbose]
      Taperole::Notifier.notify_observers(:start)
      if Kernel.system(cmd)
        Taperole::Notifier.notify_observers(:success)
      else
        Taperole::Notifier.notify_observers(:fail)
      end
    end

    def enforce_roles_path!
      Dir.mkdir('.tape') unless Dir.exist?('.tape')

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

    def hosts_flag(options)
      limit = options[:limit]
      "-l #{limit}" if limit
    end

    def inventory_file(options)
      options[:inventory_file] || "#{tapefiles_dir}/hosts"
    end
  end
end
