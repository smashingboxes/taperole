require 'pry-byebug'

module Taperole
  module Installer
    include Helpers::Files
    include Thor::Actions

    protected

    def install_tape
      File.open('.gitignore', 'r+') { |f| f.puts '.tape' unless f.read =~ /^\.tape$/ }
      mkdir tapefiles_dir
      if fe_app? && !rails_app?
        puts '🔎  JS/HTML app detected'.pink
        copy_static_app_examples
      elsif rails_app?
        puts '🔎  Rails app detected'.pink
        copy_basic_examples
      end
      create_roles_dir
      create_inventory_file
      create_ssh_keys_dir
      if ask 'Are you going to use vagrant? (y/n): '
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
      %w(omnibox deploy tape_vars).each do |base_filename|
        copy_example(
          "templates/static_html/#{base_filename}.example.yml",
          "#{tapefiles_dir}/#{base_filename}.yml"
        )
      end
    end

    def copy_basic_examples
      %w(omnibox deploy tape_vars rake).each do |base_filename|
        copy_example(
          "templates/base/#{base_filename}.example.yml",
          "#{tapefiles_dir}/#{base_filename}.yml"
        )
      end
    end

    def uninstall_tape
      rm "#{tapefiles_dir}/omnibox.yml"
      rm "#{tapefiles_dir}/deploy.yml"
      rm "#{tapefiles_dir}/tape_vars.yml"
      rm "#{tapefiles_dir}/rake.yml"
      rm "#{tapefiles_dir}/roles"
      rm "#{tapefiles_dir}/hosts"
      rm "#{tapefiles_dir}/dev_keys"
      rm "#{local_dir}/Vagrantfile"
    end

    def rm(file)
      print 'Deleting '.red
      puts file
      FileUtils.rm_r file
    end

    def mkdir(name)
      print "#{::Pathname.new(name).basename}: "
      begin
        FileUtils.mkdir name
        success
      rescue Errno::EEXIST
        exists
      rescue StandardError => e
        error
        raise e
      end
    end

    def copy_example(file, cp_file)
      print "#{::Pathname.new(cp_file).basename}: "
      begin
        if File.exist?(cp_file.to_s)
          exists
        else
          FileUtils.cp("#{tape_dir}/#{file}", cp_file.to_s)
          success
        end
      rescue StandardError => e
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
