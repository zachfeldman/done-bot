require 'slack-ruby-bot'

COUNTER = {}

module DoneBot
  class App < SlackRubyBot::App
  end

  class NewCounter < SlackRubyBot::Commands::Base
    match /^Setup a new counter for (?<counter_name>\w*)\?$/ do |client, data, match|
      COUNTERS[match[:counter_name]] = 0
      send_message client, data.channel, "I setup a new counter for #{match[:counter_name]}."
    end
  end

  class Done < SlackRubyBot::Commands::Base
    match /^I'm done with (?<counter_name>\w*)\?$/ do |client, data, match|
      COUNTERS[match[:counter_name]] += 1
      finished_sayings = ["Great job!", "Nice work.", "Keep at it.", "Do, or do not. There is no try!"]
      send_message client, data.channel, finished_sayings[(rand*4).ceil-1]
    end
  end

  class AmountDone < SlackRubyBot::Commands::Base
    match /^How many people are done with (?<counter_name>\w*)\?$/ do |client, data, match|
      send_message client, data.channel, "#{COUNTERS[match[:counter_name]]} are done."
    end
  end

  class Reset < SlackRubyBot::Commands::Base
    match /^Reset the (?<counter_name>\w*) counter$/ do |client, data, match|
      COUNTERS[match[:counter_name]] = 0
      send_message client, data.channel, "#{COUNTERS[match[:counter_name]]} set to 0."
    end
  end
end

DoneBot::App.instance.run
