require 'slack-ruby-bot'
require 'json'

class EngineerNotifier < SlackRubyBot::Bot
  
  MENTIONS = JSON.parse ENV['MENTIONS']
 
  command 'ping' do |client, data, match|
    client.say(text: 'pong', channel: data.channel)
  end

  match /.*/ do |client, data, match|
    data[:attachments].each do |attachment|
      MENTIONS.each do |mention|
        if attachment.text.include?(mention)
          echo_mention(data, client, mention)
        end
      end
    end
  end

  def self.echo_mention(data, client, mention)
    client.say(channel: data.channel, text: "^ #{mention}")
  end
end

EngineerNotifier.run
