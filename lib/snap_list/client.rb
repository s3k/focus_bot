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
      load "#{__dir__}/handler/base.rb"
      load "#{__dir__}/handler/callback.rb"
      load "#{__dir__}/handler/inline.rb"
      load "#{__dir__}/handler/message.rb"

      case resp.message
      when Telegram::Bot::Types::Message
        Handler::Message.new(resp).call

      when Telegram::Bot::Types::InlineQuery
        Handler::Inline.new(resp).call

      when Telegram::Bot::Types::CallbackQuery
        Handler::Callback.new(resp).call

      end
    end

    def bot_listen!
      Telegram::Bot::Client.run(@token, logger: Logger.new($stderr)) do |bot|
        bot.listen do |message|
          resp = Struct.new(:bot, :message).new(bot, message)
          event_handler(resp)
        end
      end
    end
  end
end
