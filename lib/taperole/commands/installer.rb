module Taperole
  module Commands
    class Installer < Thor
      include Taperole::Installer
      include Taperole::Helpers::Logging

      option :vagrant, type: :boolean
      desc 'install', 'Creates all necessary hosts and config files'
      def install
        install_tape
      end

      desc 'uninstall', 'Cleans up files generated by the installer'
      def uninstall
        uninstall_tape
      end
    end
  end
end
