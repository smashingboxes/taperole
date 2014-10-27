module SmashingBoxer
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

    protected

    def require_opt(name)
      unless opts[name.to_sym]
        raise UnspecifiedOption, "Option #{name} must be specified to do this!"
      end
    end

    def do_action
      raise NotImplementedError, "ExecutionModule is an abstract "\
        "class and can not handle action execution itself"
    end
  end
end

require 'smashing_boxer/ansible_runner'
require 'smashing_boxer/qemu_provisioner'
