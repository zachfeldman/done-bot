require 'slack-ruby-bot'

COUNTERS = {}

module DoneBot
  class App < SlackRubyBot::App
  end

  class Counter < SlackRubyBot::Commands::Base
    match /^Setup a counter for (?<counter_name>\w*)$/ do |client, data, match|
      COUNTERS[match[:counter_name]] = 0
      send_message client, data.channel, "I setup a new counter for #{match[:counter_name]}."
    end
  end

  class Done < SlackRubyBot::Commands::Base
    match /^Done with (?<counter_name>\w*)$/ do |client, data, match|
      finished_sayings = ["Great job!", "Nice work.", "Keep at it.", "Do, or do not. There is no try!"]
      if COUNTERS[match[:counter_name]]
        COUNTERS[match[:counter_name]] += 1     
        response = finished_sayings[(rand*4).ceil-1] 
      else
        response = "Sorry, there's no counter with that name. If you'd like to set one up, just say, \"Setup a counter for #{match[:counter_name]}\""
      end
      send_message client, data.channel, response
    end
  end

  class AmountDone < SlackRubyBot::Commands::Base
    match /^How many are done with (?<counter_name>\w*)$/ do |client, data, match|
      if COUNTERS[match[:counter_name]]
        response = "#{COUNTERS[match[:counter_name]]} are done."
      else
        response = "Sorry, there's no counter with that name. If you'd like to set one up, just say, \"Setup a counter for #{match[:counter_name]}\""
      end
      send_message client, data.channel, response
    end
  end

  class Reset < SlackRubyBot::Commands::Base
    match /^Reset the (?<counter_name>\w*)$/ do |client, data, match|
      if COUNTERS[match[:counter_name]]
        COUNTERS[match[:counter_name]] = 0
        response = "#{COUNTERS[match[:counter_name]]} has been reset to 0."
      else
        response = "Sorry, there's no counter with that name. If you'd like to set one up, just say, \"Setup a counter for #{match[:counter_name]}\""
      end
      send_message client, data.channel, response
    end
  end
end

DoneBot::App.instance.run
