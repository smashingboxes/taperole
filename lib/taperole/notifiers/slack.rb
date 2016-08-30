require 'slack-notifier'

module Taperole
  module Notifiers
    class Slack
      def initialize(webhook_url, deploy_info)
        @notifier = ::Slack::Notifier.new webhook_url
        @notifier.username = 'Tape'
        @deploy_info = deploy_info
      end

      def update(status)
        @status = status
        @notifier.ping(
          "",
          # TODO: Fill in real icon url
          icon_url: 'https://image.freepik.com/free-icon/adhesive-tape_318-42276.png',
          attachments: attachments
        )
      end

      private

      def attachments
        a = {}
        a[:text] = message
        a[:color] = color
        a[:fields] = fields unless @status == :start
        [a]
      end

      def fields
        [
          {
            title: "Project",
            value: project_link,
            short: true
          },
          {
            title: "Hosts/Env",
            value: @deploy_info[:hosts],
            short: true
          },
          {
            title: "Author",
            value: @deploy_info[:user],
            short: true
          }
        ]
      end

      def color
        case @status
        when :start   then "#a9a9a9"
        when :success then "good"
        when :fail    then "danger"
        end
      end

      def gh_link_base
        @deploy_info[:repo].sub(/^git@github.com:/, 'http://github.com/').sub(/.git$/, '')
      end

      def project_link
        "<#{gh_link_base}|#{@deploy_info[:app_name]}>"
      end

      def message
        case @status
        when :start
          user  = @deploy_info[:user]
          app   = @deploy_info[:app_name]
          hosts = @deploy_info[:hosts]
          "#{user} started deploying #{app} to #{hosts}"
        when :success
          "The deploy was successful!"
        when :fail
          "The deploy failed!"
        end
      end
    end
  end
end
