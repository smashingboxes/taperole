require 'tape/ansible_runner'

module TapeBoxer
  class Ansible < Thor
    include TapeBoxer::AnsibleRunner

    class_option :limit,
                 type: :string,
                 aliases: :l,
                 desc: "Limits ansible runs to hosts matching the given pattern"
    class_option :task,
                 type: :string,
                 aliases: :T,
                 desc: "Name of the rake task to execute"

    desc 'everything', 'Initial setup of a server'
    def everything
      valid_preconfigs ? ansible : puts("Not a Rails or JS app")
    end

    desc 'deploy', 'Deploy the latest version of the app'
    def deploy
      puts 'deploying'
    end
  end
end
