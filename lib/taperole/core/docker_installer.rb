require 'pathname'

module Taperole
  class DockerInstaller < Thor
    include Taperole::Helpers::Logging

    no_commands do
      def docker_installed_precheck
        unless exec('docker -v') =~ /Docker version/
          logger.info "⚠️  You must have Docker installed to use tape".yellow
          if OS.mac?
            logger.info "🔗  https://docs.docker.com/docker-for-mac/install/"
            return false
          else
            logger.info "🔗  https://docs.docker.com/engine/installation/"
            return false
          end
        end
        return true
      end


      def docker_compose_installed_precheck
        unless exec('docker-compose version') =~ /docker-compose version/
          logger.info "⚠️  You must have Docker Compose installed to use tape".yellow
          logger.info "🔗  https://docs.docker.com/compose/install/"
          return false
        end
        return true
      end

      def exec(cmd)
        `#{cmd}`
      end
    end
  end
end
