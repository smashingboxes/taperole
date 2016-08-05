require 'thor'

module Taperole
  module Commands
    class Tape < Thor
      class_option :verbose, type: :boolean

      map %w[--version -v] => :__print_version

      desc "--version, -v", "print the version"
      def __print_version
        puts Taperole::VERSION
      end

      desc 'ansible [COMMAND]', 'run tapes ansible commands'
      subcommand 'ansible', Ansible

      desc 'installer [COMMAND]', 'install and uninstall tape'
      subcommand 'installer', Installer
    end
  end
end
