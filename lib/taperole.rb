require 'thor'
require 'taperole/helpers/string_color_monkeypatch'

module Taperole
  autoload :VERSION, 'taperole/version'
  autoload :AnsibleRunner, 'taperole/core/ansible_runner'
  autoload :Installer, 'taperole/core/installer'

  module Commands
    autoload :Tape, 'taperole/commands/tape'
    autoload :Installer, 'taperole/commands/installer'
    autoload :Ansible, 'taperole/commands/ansible'
  end

  module Helpers
    autoload :Files, 'taperole/helpers/files'
  end
end
