require 'slack-ruby-bot'
require 'json'

module SlackBot
  class EngineerNotifier < SlackRubyBot::Bot

    MENTIONS_TO_HANDLES = JSON.parse ENV['MENTIONS_TO_HANDLES']
    CHANNEL_IDS = JSON.parse ENV['CHANNEL_IDS']
    BOT_EMOJI = ENV['BOT_EMOJI'] || ':dragon_face:'

    match /.*/ do |client, data, match|
      post_emoji_reaction(data: data, client: client) if post_includes_bot_emoji?(data)

      if valid_channel?(data.channel)
        data[:attachments].try(:each) do |attachment|
          next unless attachment.text

          MENTIONS_TO_HANDLES.each do |mention, handle|
            if attachment.text.include?(mention)
              post_notification(data: data, handle: handle, client: client)
            end
          end
        end
      end
    end

    def self.post_notification(data:, handle:, client:)
      client.say(channel: data.channel, text: "^ <#{handle}>")
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
