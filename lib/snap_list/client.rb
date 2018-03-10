module SnapList
  class Client
    attr_accessor :token

    def initialize(opt={})
      @token = opt[:token]
    end

    def call
      bot_listen!
    end

    private

    def event_handler(resp)
      load "#{__dir__}/handler_base.rb"
      load "#{__dir__}/callback_handler.rb"
      load "#{__dir__}/inline_handler.rb"
      load "#{__dir__}/message_handler.rb"

      case resp.message
      when Telegram::Bot::Types::Message
        MessageHandler.new(resp).call

      when Telegram::Bot::Types::InlineQuery
        InlineHandler.new(resp).call

      when Telegram::Bot::Types::CallbackQuery
        CallbackHandler.new(resp).call

      end
    end

    def bot_listen!
      Telegram::Bot::Client.run(@token) do |bot|
        bot.listen do |message|
          resp = Struct.new(:message, :bot).new(message, bot)
          event_handler(resp)
        end
      end
    end
  end
end
