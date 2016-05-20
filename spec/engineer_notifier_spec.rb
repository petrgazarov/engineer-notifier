module SlackBot
  describe EngineerNotifier do
    def app
      EngineerNotifier.instance
    end

    let(:client) { SlackRubyBot::Client.new }

    context 'when message includes bot emoji' do
      it 'posts a reply emoji' do
        expect(message: 'Some text :dragon_face:', channel: 'SOMECHANNELID')
          .to respond_with_slack_message(':heart:')
      end
    end

    context 'when message does not include bot emoji' do
      it 'does not post reply emoji' do
        expect(client).not_to receive(:message).with(channel: 'SOMECHANNELID', text: ':heart:')

        message_command = SlackRubyBot::Hooks::Message.new

        message_command.call(
          client,
          Hashie::Mash.new(text: 'Some message', channel: 'SOMECHANNELID')
        )
      end
    end

    context 'when channel is valid' do
      context 'when "attachments" property exists' do
        context 'when text property of attachment includes a valid mention' do
          it 'replies with mention of the user to the correct channel' do
            expect(client).to receive(:message).with(channel: 'SOMECHANNELID', text: '^ <@PETRHANDLE>')

            message_command = SlackRubyBot::Hooks::Message.new

            message_command.call(
              client,
              Hashie::Mash.new(text: 'Some message', channel: 'SOMECHANNELID', attachments: [{"text": "@petr"}])
            )
          end

          it 'handles multiple mentions in one attachment text' do
            expect(client).to receive(:message).with(channel: 'SOMECHANNELID', text: '^ <@PETRHANDLE>')
            expect(client).to receive(:message).with(channel: 'SOMECHANNELID', text: '^ <@ENGINEERSHANDLE>')

            message_command = SlackRubyBot::Hooks::Message.new

            message_command.call(
              client,
              Hashie::Mash.new(text: 'Some message', channel: 'SOMECHANNELID', attachments: [{"text": "some text @petr some text @engineers"}])
            )
          end

          it 'handles multiple attachments' do
            expect(client).to receive(:message).with(channel: 'SOMECHANNELID', text: '^ <@PETRHANDLE>')
            expect(client).to receive(:message).with(channel: 'SOMECHANNELID', text: '^ <@ENGINEERSHANDLE>')

            message_command = SlackRubyBot::Hooks::Message.new

            message_command.call(
              client,
              Hashie::Mash.new(
                text: 'Some message',
                channel: 'SOMECHANNELID',
                attachments: [{"text": "some text @petr"}, {"text": "some text @engineers"}]
              )
            )
          end
        end

        context 'when text property of attachment does not include a valid mention' do
          it 'does not reply with mention of the user' do
            expect(client).not_to receive(:message)

            message_command = SlackRubyBot::Hooks::Message.new

            message_command.call(
              client,
              Hashie::Mash.new(
                text: 'Some message',
                channel: 'SOMECHANNELID',
                attachments: [{"text": "no mention here"}]
              )
            )
          end
        end
      end

      context 'when "attachments" property does not exist' do
        it 'does not reply with mention' do
            expect(client).not_to receive(:message)

            message_command = SlackRubyBot::Hooks::Message.new

            message_command.call(
              client,
              Hashie::Mash.new(
                text: 'Some message',
                channel: 'SOMECHANNELID'
              )
            )
        end
      end
    end

    context 'when channel is not valid' do
      it 'does not reply with mention' do
        expect(client).not_to receive(:message)

        message_command = SlackRubyBot::Hooks::Message.new

        message_command.call(
          client,
          Hashie::Mash.new(
            text: 'Some message',
            channel: 'INVALIDCHANNEL',
            attachments: [{"text": "@petr mention"}]
          )
        )
      end
    end
  end
end
