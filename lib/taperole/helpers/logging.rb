require 'logger'

module Taperole
  module Helpers
    module Logging
      def initialize(*_args)
        super
        logger.level = logger_level
        logger.formatter = proc do
          "#{msg}\n"
        end
      end

      def logger
        Logging.logger
      end

      def self.logger
        @logger ||= Logger.new(STDOUT)
      end

      private

      def logger_level
        if options[:debug]
          Logger::DEBUG
        elsif options[:verbose]
          Logger::INFO
        elsif options[:quiet]
          Logger::ERROR
        else
          Logger::INFO
        end
      end
    end
  end
end
