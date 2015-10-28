require 'slack-ruby-bot'

counter = 0

module DoneBot
  class App < SlackRubyBot::App
  end

  class Done < SlackRubyBot::Commands::Base
    def self.call(client, data, _match)
      counter += 1
      finished_sayings = ["Great job!", "Nice work.", "Keep at it.", "Do, or do not. There is no try!"]
      client.message text: finished_sayings[(rand*4).ceil-1], channel: data.channel
    end
  end

  class AmountDone < SlackRubyBot::Commands::Base
    def self.call(client, data, _match)
      client.message text: "counter is currently at #{counter}.", channel: data.channel
    end
  end

  class Reset < SlackRubyBot::Commands::Base
    def self.call(client, data, _match)
      counter = 0
      client.message text: "counter reset to 0.", channel: data.channel
    end
  end
end

DoneBot::App.instance.run
