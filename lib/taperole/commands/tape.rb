require 'thor'

module Taperole
  module Commands
    class Tape < Thor
      include Taperole::Helpers::Files

      class_option :verbose, type: :boolean
      class_option :silent, type: :boolean

      map %w[--version -v] => :__print_version

      desc "--version, -v", "print the version"
      def __print_version
        puts Taperole::VERSION
      end

      desc 'ansible [COMMAND]', 'run tapes ansible commands'
      subcommand 'ansible', Ansible

      desc 'installer [COMMAND]', 'install and uninstall tape'
      subcommand 'installer', Installer

      desc 'overwrite [ROLE]', 'Overwrite a taperole ansible role'
      def overwrite_role(role)
        FileUtils.cp_r("#{tape_dir}/roles/#{role}", "taperole/roles/")
      end
    end
  end
end
