$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))

ENV['MENTIONS_TO_HANDLES'] = '{"@petr": "@PETRHANDLE", "@engineers": "@ENGINEERSHANDLE"}'
ENV['CHANNEL_IDS'] = '["SOMECHANNELID"]'

require 'slack-ruby-bot/rspec'
require 'engineer_notifier'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
