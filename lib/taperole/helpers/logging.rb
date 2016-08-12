require 'logger'

module Taperole
  module Helpers
    module Logging
      def initialize(*_args)
        super
        if options[:debug]
          logger.level = Logger::DEBUG
        elsif options[:verbose]
          logger.level = Logger::INFO
        elsif options[:quiet]
          logger.level = Logger::ERROR
        else
          logger.level = Logger::INFO
        end
        logger.formatter = proc do |severity, datetime, progname, msg|
           "#{msg}\n"
        end
      end

      def logger
        Logging.logger
      end

      def self.logger
        @logger ||= Logger.new(STDOUT)
      end
    end
  end
end
