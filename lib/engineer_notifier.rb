require 'slack-ruby-bot'
require 'json'

module SlackBot
  class EngineerNotifier < SlackRubyBot::Bot
    MENTIONS = JSON.parse ENV['MENTIONS']
    CHANNEL_IDS = JSON.parse ENV['CHANNEL_IDS']
    BOT_EMOJI = ENV['BOT_EMOJI'] || ':dragon_face:'

    match /.*/ do |client, data, match|
      if post_includes_bot_emoji?(data)
        post_emoji_reaction(data: data, client: client)
      end

      if valid_channel?(data.channel)
        data[:attachments].try(:each) do |attachment|
          MENTIONS.each do |mention|
            if attachment.text.include?(mention)
              echo_mention(data: data, mention: mention, client: client)
            end
          end
        end
      end
    end

    def self.echo_mention(data:, mention:, client:)
      client.say(channel: data.channel, text: "^ #{mention}")
    end

    def self.valid_channel?(channel_id)
      CHANNEL_IDS.include?(channel_id)
    end

    def self.post_includes_bot_emoji?(data)
      data.text.include?(BOT_EMOJI)
    end

    def self.post_emoji_reaction(data:, client:)
      client.say(channel: data.channel, text: "#{BOT_EMOJI}:heart:")
    end
  end
end
