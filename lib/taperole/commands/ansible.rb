module Taperole
  module Commands
    class Ansible < Thor
      include Taperole::AnsibleRunner
      include Taperole::Helpers::Logging

      class_option :limit,
                   type: :string,
                   aliases: :l,
                   desc: 'Limits ansible runs to hosts matching the given pattern'
      class_option :task,
                   type: :string,
                   aliases: :T,
                   desc: 'Name of the rake task to execute'
      class_option :inventory,
                   aliases: :i,
                   type: :string,
                   desc: 'Do actions with the given inventory file'
      class_option :name,
                   aliases: :n,
                   type: :string,
                   desc: 'The name of the machine to operate on'
      class_option :port,
                   aliases: :p,
                   type: :numeric,
                   desc: 'The port that the machine is listening on for SSH connections'
      class_option :tags,
                   aliases: :t,
                   type: :string,
                   desc: 'Only run plays and tasks tagged with these values'
      class_option :role,
                   aliases: :r,
                   type: :string,
                   desc: 'Name of the role to operate on'
      class_option :extras
                   aliases: :e,
                   type: :string,
                   desc: 'Extra variables to be passed into ansible'

      class_option :'ask-vault-pass', type: :boolean, desc: 'Ask for Ansible vault password'

      class_option :book,
                   aliases: :b,
                   type: :string,
                   desc: 'A custom playbook to run'

      desc 'everything', 'Initial setup of a server'
      def everything
        Taperole::Notifier.register_notifiers(options)
        valid_preconfigs ? ansible(options: options) : puts("Not a Rails or JS app")
      end

      desc 'deploy', 'Deploy the latest version of the app'
      def deploy
        Taperole::Notifier.register_notifiers(options)
        ansible_deploy(options: options)
      end
    end
  end
end
