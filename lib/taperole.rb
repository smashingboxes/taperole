require 'thor'
require 'colorize'

module Taperole
  autoload :VERSION, 'taperole/version'
  autoload :AnsibleRunner, 'taperole/core/ansible_runner'
  autoload :Installer, 'taperole/core/installer'
  autoload :Notifier, 'taperole/core/notifier'

  module Commands
    autoload :Tape, 'taperole/commands/tape'
    autoload :Installer, 'taperole/commands/installer'
    autoload :Ansible, 'taperole/commands/ansible'
  end

  module Helpers
    autoload :Files, 'taperole/helpers/files'
  end

  module Notifiers
    autoload :Slack, 'taperole/notifiers/slack'
  end
end
