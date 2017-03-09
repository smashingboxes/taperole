module Taperole
  module Helpers
    module Files
      def fe_app?
        !Dir["#{local_dir}/package.json"].empty?
      end

      def rails_app?
        !Dir["#{local_dir}/config.ru"].empty?
      end

      def tape_dir
        File.realpath(File.join(__dir__, '../../../'))
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

      def rm(file)
        logger.info 'Deleting '.red + file
        FileUtils.rm_r file
      end

      def mkdir(name)
        file_text = "#{::Pathname.new(name).basename}: "
        begin
          FileUtils.mkdir name
          success(file_text)
        rescue Errno::EEXIST
          exists(file_text)
        rescue StandardError => e
          error(file_text)
          raise e
        end
      end

      def copy_example(file, cp_file)
        file_text = "#{::Pathname.new(cp_file).basename}: "
        begin
          if File.exist?(cp_file.to_s)
            exists(file_text)
          else
            FileUtils.cp("#{tape_dir}/#{file}", cp_file.to_s)
            success(file_text)
          end
        rescue StandardError => e
          error(file_text)
          raise e
        end
      end

      private

      def success(file_text)
        logger.info file_text + '✔'.green
      end

      def error(file_text)
        logger.info file_text + '✘'.red
      end

      def exists(file_text)
        logger.info file_text + '✘ (Exists)'.yellow
      end
    end
  end
end
