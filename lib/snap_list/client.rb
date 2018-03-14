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
        bot.logger.info('Bot has been started')
        bot.listen do |message|
          # resp = Struct.new(:message, :bot).new(message, bot)
          # event_handler(resp)
          case message
          when Telegram::Bot::Types::CallbackQuery
            # Here you can handle your callbacks from inline buttons
            if message.data == 'touch'
              bot.api.send_message(chat_id: message.from.id, text: "Don't touch me!")
            end
          when Telegram::Bot::Types::Message
            kb = [
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Go to Google', url: 'https://google.com'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Touch me', callback_data: 'touch'),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Switch to inline', switch_inline_query: 'some text')
            ]
            markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
            bot.api.send_message(chat_id: message.chat.id, text: 'Make a choice', reply_markup: markup)
          end
        end
      end
    end
  end
end
