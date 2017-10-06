module Taperole
  module Commands
    class Installer < Thor
      include Taperole::Helpers::Logging

      desc 'install', 'Creates all necessary docker files'
      def install
        if prechecks_pass
          install_tape
        end
      end

      no_commands do
        def prechecks_pass
          docker_installed_precheck &&
            docker_compose_installed_precheck
        end

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
end
