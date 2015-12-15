require 'slack-notifier'
require 'pry'
class SlackNotifier
  def initialize(runner, webhook_url)
    @notifier = Slack::Notifier.new webhook_url
  end

  def update(state)
    @state = state
    @notifier.ping "",
      # TODO: Fill in real icon url
      icon_url: "https://image.freepik.com/free-icon/adhesive-tape_318-42276.png",
      attachments: [attachments]
  end

  private

  def attachments
    a = {}
    a[:text] = message
    a[:color] = color
    a[:fields] = fields unless status == :start
    a
  end

  def fields
      [
        { title: "Project", value: app_name, short: true },
        { title: "Environment", value: environment, short: true },
        { title: "Author", value: user, short: true },
        { title: "Commit", value: commit_sha, short: true }
      ]
  end

  def color
    case @state[:status]
    when :start   then "#a9a9a9"
    when :success then "good"
    when :fail    then "danger"
    end
  end

  def message
    case @state[:status]
    when :start   then "A deploy has begun..."
    when :success then "The deploy was successful!"
    when :fail    then "The deploy failed!"
    end
  end

  def status
    @state[:status]
  end

  def app_name
    @state[:runner].config["app_name"]
  end

  def user
    `whoami`
  end

  def environment
    # TODO
    ""
  end

  def commit_sha
    # TODO
    ""
  end
end
