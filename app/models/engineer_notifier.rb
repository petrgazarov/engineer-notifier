require 'slack-ruby-bot'
require 'json'

class EngineerNotifier < SlackRubyBot::Bot
  MENTIONS = JSON.parse ENV['MENTIONS']
  CHANNELS = JSON.parse ENV['CHANNELS']

  match /.*/ do |client, data, match|
    unless valid_channel?(data.channel)
      data[:attachments].try(:each) do |attachment|
        MENTIONS.each do |mention|
          if attachment.text.include?(mention)
            echo_mention(data: data, client: client, mention: mention)
          end
        end
      end
    end
  end

  def self.echo_mention(data:, client:, mention:)
    client.say(channel: data.channel, text: "^ #{mention}")
  end

  def self.valid_channel?(channel)
    CHANNELS.include?(channel)
  end
end

EngineerNotifier.run
