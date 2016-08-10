require 'singleton'
require 'yaml'

module Taperole
  class Notifier
    include ::Singleton

    attr_accessor :observers

    def initialize
      @observers = []
    end

    class << self
      include Taperole::Helpers::Files

      def register_notifiers(options)
        if config["slack_webhook_url"]
          slack_notifier = Taperole::Notifiers::Slack.new(
            config["slack_webhook_url"],
            deploy_info(options)
          )
          instance.observers.push(slack_notifier)
        end
      end

      def config
        @config ||= YAML.load_file("#{tapefiles_dir}/tape_vars.yml")
      end

      def deploy_info(options)
        {
          app_name: config["app_name"],
          user: `whoami`.chomp,
          hosts: options[:limit] || 'default',
          repo: config["be_app_repo"] || ''
        }
      end

      def notify_observers(state)
        instance.observers.each do |observer|
          observer.update(state)
        end
      end
    end
  end
end
