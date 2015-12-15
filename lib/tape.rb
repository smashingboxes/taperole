require 'erb'
require 'fileutils'
require 'yaml'
require_relative 'tape/notifiers/slack.rb'

module TapeBoxer
  class InvalidAction < StandardError; end
  class ActionError < StandardError; end
  class UnspecifiedOption < StandardError; end

  class Action < Struct.new(:name, :proc, :description); end
  class RegisteredModule < Struct.new(:name, :klass); end

  def self.register_module(name, klass)
    self.registered_modules[name] = RegisteredModule.new(name, klass)
  end

  def self.registered_modules
    @modules ||= Hash.new
  end

  class ExecutionModule
    attr_reader :opts
    def initialize(opts)
      @opts = opts
      register_notifers
    end

    def self.actions
      @actions
    end

    def self.action(name, opts = '', doc = '')
      @actions ||= Hash.new
      @actions[name.to_sym] = Action.new(name, opts, doc)
    end

    # Set or return module_name
    def self.module_name(name = nil)
      @module_name = (name || @module_name)
    end

    def actions
      self.class.actions
    end

    def fe_app?
      !Dir["#{local_dir}/gulpfile.*"].empty?
    end

    def rails_app?
      !Dir["#{local_dir}/config.ru"].empty?
    end

    def execute_action(action)
      action = action.to_sym
      unless actions.include?(action)
        raise InvalidAction, "#{action} is not a valid action!"
      end

      unless system("ansible-playbook --version >/dev/null")
        raise InvalidAction, "ansible-playbook must be on your PATH to use this tool"
      end

      self.instance_eval &actions[action].proc
    end

    def config
      @config ||= YAML.load_file("#{tapefiles_dir}/tape_vars.yml")
    end

    protected

    def require_opt(name)
      unless opts[name.to_sym]
        raise UnspecifiedOption, "Option --#{name} must be specified to do this!"
      end
    end

    private

    def register_notifers
      if config["slack_webhook_url"]
        add_observer(::SlackNotifier.new(self, config["slack_webhook_url"]))
      end
    end

    def add_observer(observer)
      @observers = [] unless @observers
      @observers.push(observer)
    end

    def notify_observers(state)
      @observers.each do |observer|
        observer.update(state)
      end
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

Dir[File.dirname(__FILE__) + "/tape/*.rb"].each {|file| require file }
