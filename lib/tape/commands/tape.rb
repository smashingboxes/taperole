require 'thor'
require 'tape/commands/ansible'

module TapeBoxer
  class Tape < Thor
    class_option :verbose, type: :boolean, aliases: :v

    desc 'ansible [COMMAND]', 'run tapes ansible commands'
    subcommand 'ansible', Ansible
  end
end
