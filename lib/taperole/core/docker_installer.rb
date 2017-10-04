require 'pathname'
require 'pry-byebug'

module Taperole
  class DockerInstaller
    def docker_installed_precheck
      unless `docker -v` =~ /Docker version/
        logger.info "You must have Docker Installed to use tape"
        if OS.mac?
          logger.info "https://docs.docker.com/docker-for-mac/install/"
          exit 1
        else
          logger.info "https://docs.docker.com/engine/installation/"
          exit 1
        end
      end
      return true
    end
  end
end
