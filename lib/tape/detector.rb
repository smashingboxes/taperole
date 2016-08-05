module TapeBoxer
  module Detector
    def fe_app?
      !Dir["#{local_dir}/package.json"].empty?
    end

    def rails_app?
      !Dir["#{local_dir}/config.ru"].empty?
    end

    def tape_dir
      File.realpath(File.join(__dir__, '../'))
    end

    def local_dir
      Dir.pwd
    end

    def tapefiles_dir
      local_dir + '/taperole'
    end

    def tapecfg_dir
      local_dir + '/.tape'
    end
  end
end
