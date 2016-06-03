require 'pathname'
module TapeBoxer
  class Installer < ExecutionModule
    TapeBoxer.register_module :installer, self

    action :install,
           proc { install },
           'Creates all necessary hosts and config files'
    action :uninstall,
           proc { uninstall },
           'Cleans up files generated by the installer'

    def initialize(*args)
      super
    end

    protected

    def install
      File.open('.gitignore', 'r+') { |f| f.puts '.tape' unless f.read =~/^\.tape$/ }
      mkdir tapefiles_dir
      if fe_app? && !rails_app?
        puts '🔎  JS/HTML app detected'.pink
        copy_static_app_examples
      else rails_app?
        puts '🔎  Rails app detected'.pink
        copy_basic_examples
      end
      create_roles_dir
      create_inventory_file
      create_ssh_keys_dir
      print 'Are you going to use vagrant? (y/n): '
      if gets.chomp == 'y'
        copy_example 'Vagrantfile', 'Vagrantfile'
      end
    end

    def create_roles_dir
      mkdir "#{tapefiles_dir}/roles"
      `touch #{tapefiles_dir}/roles/.keep`
    end

    def create_ssh_keys_dir
      mkdir "#{tapefiles_dir}/dev_keys"
    end

    def create_inventory_file
      copy_example 'templates/base/hosts.example', "#{tapefiles_dir}/hosts"
    end

    def copy_static_app_examples
      ["omnibox", "deploy", 'tape_vars', 'rake'].each do |base_filename|
        copy_example(
          "templates/static_html/#{base_filename}.example.yml",
          "#{tapefiles_dir}/#{base_filename}.yml"
        )
      end
    end

    def copy_basic_examples
      ["omnibox", "deploy", 'tape_vars', 'rake'].each do |base_filename|
        copy_example(
          "templates/static_html/#{base_filename}.example.yml",
          "#{tapefiles_dir}/#{base_filename}.yml"
        )
      end
    end

    def uninstall
      rm "#{tapefiles_dir}/omnibox.yml"
      rm "#{tapefiles_dir}/deploy.yml"
      rm "#{tapefiles_dir}/tape_vars.yml"
      rm "#{tapefiles_dir}/rake.yml"
      rm "#{tapefiles_dir}/roles"
      rm "#{tapefiles_dir}/hosts"
      rm "#{tapefiles_dir}/dev_keys"
      rm "Vagrantfile"
    end

    def rm(file)
      print 'Deleting '.red
      FileUtils.rm_r "#{local_dir}#{file}"
      puts file
    end

    def mkdir(name)
      print "#{::Pathname.new(name).basename}: "
      begin
        FileUtils.mkdir name
        success
      rescue Errno::EEXIST
        exists
      rescue Exception => e
        error
        raise e
      end
    end

    def copy_example(file, cp_file)
      print "#{::Pathname.new(cp_file).basename}: "
      begin
        if File.exist?("#{cp_file}")
          exists
        else
          FileUtils.cp("#{tape_dir}/#{file}", "#{cp_file}")
          success
        end
      rescue Exception => e
        error
        raise e
      end
    end

    def success
      puts '✔'.green
    end

    def error
      puts '✘'.red
    end

    def exists
      puts '✘ (Exists)'.yellow
    end
  end
end

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def pink
    colorize(35)
  end
end
