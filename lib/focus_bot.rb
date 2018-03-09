require 'dotenv/load'
require "focus_bot/version"
require 'telegram/bot'

module FocusBot
  def self.run
    Telegram::Bot::Client.run(ENV["TG_TOKEN"]) do |bot|
      bot.listen do |message|
        case message.text
        when '/start'
          bot.api.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
        when '/stop'
          bot.api.send_message(chat_id: message.chat.id, text: "Bye, #{message.from.first_name}")
        end
      end
    end
  end
end
