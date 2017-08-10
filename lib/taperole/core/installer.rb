require 'pathname'

module Taperole
  module Installer
    include Taperole::Helpers::Files
    include Thor::Actions

    protected

    def install_tape
      add_tape_to_gitignore
      mkdir tapefiles_dir
      create_tape_files
      create_roles_dir
      create_inventory_file
      create_ssh_keys_dir
      handle_vagrantfile
    end

    def uninstall_tape
      rm "#{tapefiles_dir}/provision.yml"
      rm "#{tapefiles_dir}/deploy.yml"
      rm "#{tapefiles_dir}/tape_vars.yml"
      rm "#{tapefiles_dir}/rake.yml"
      rm "#{tapefiles_dir}/roles"
      rm "#{tapefiles_dir}/hosts"
      rm "#{tapefiles_dir}/dev_keys"
      rm "#{local_dir}/Vagrantfile"
    end

    private

    def add_tape_to_gitignore
      File.open('.gitignore', 'r+') { |f| f.puts '.tape' unless f.read =~ /^\.tape$/ }
    end

    def create_tape_files
      if fe_app? && !rails_app?
        logger.info '🔎  JS/HTML app detected'.blue
        copy_static_app_examples
      elsif rails_app?
        logger.info '🔎  Rails app detected'.blue
        copy_basic_examples
      end
    end

    def copy_static_app_examples
      %w(provision deploy tape_vars).each do |base_filename|
        copy_example(
          "templates/static_html/#{base_filename}.example.yml",
          "#{tapefiles_dir}/#{base_filename}.yml"
        )
      end
    end

    def copy_basic_examples
      %w(provision deploy tape_vars rake).each do |base_filename|
        copy_example(
          "templates/base/#{base_filename}.example.yml",
          "#{tapefiles_dir}/#{base_filename}.yml"
        )
      end
    end

    def create_roles_dir
      mkdir "#{tapefiles_dir}/roles"
      `touch #{tapefiles_dir}/roles/.keep`
    end

    def create_inventory_file
      copy_example 'templates/base/hosts.example', "#{tapefiles_dir}/hosts"
    end

    def create_ssh_keys_dir
      mkdir "#{tapefiles_dir}/dev_keys"
    end

    def handle_vagrantfile
      if options[:vagrant].nil?
        options[:vagrant] = ask('Are you going to use vagrant? (y/n): ')
      end
      if options[:vagrant]
        copy_example 'Vagrantfile', 'Vagrantfile'
      end
    end
  end
end
