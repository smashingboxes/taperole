require 'pathname'

module Taperole
  class DockerInstaller < Thor
    include Taperole::Helpers::Logging

    no_commands do
      def docker_installed_precheck
        unless exec('docker -v') =~ /Docker version/
          logger.info "You must have Docker Installed to use tape"
          if OS.mac?
            logger.info "https://docs.docker.com/docker-for-mac/install/"
            return false
          else
            logger.info "https://docs.docker.com/engine/installation/"
            return false
          end
        end
        return true
      end

      def exec(cmd)
        `#{cmd}`
      end
    end
  end
end
