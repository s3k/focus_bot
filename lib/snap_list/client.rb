module SnapList
  class Client
    include SnapList::Handler
    attr_accessor :token

    ## TODO:
    # [] Продумать CRUD меню
    # [] Придумать группы
    # [] Добавить AASM
    # [x] Добавить ActiveRecord + DB

    def initialize(opt={})
      @token = opt[:token]
    end

    def call
      bot_listen!
    end

    private

    def event_handler(resp)
      load "#{__dir__}/handler.rb"

      case resp.message
      when Telegram::Bot::Types::Message
        message_handler(resp)

      when Telegram::Bot::Types::InlineQuery
        inline_handler(resp)

      when Telegram::Bot::Types::CallbackQuery
        cb_handler(resp)

      end
    end

    def send(resp, opt={})
      case resp.message
      when Telegram::Bot::Types::CallbackQuery
        chat_id = resp.message.message.chat.id
      else
        chat_id = resp.message.chat.id
      end

      opt.merge!({ chat_id: chat_id })
      resp.bot.api.send_message(opt)
    end

    def keyboard(items)
      Telegram::Bot::Types::ReplyKeyboardMarkup
        .new(keyboard: items, one_time_keyboard: true)
    end

    def button(opt={})
      Telegram::Bot::Types::InlineKeyboardButton.new(opt)
    end

    def markup
      Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: yield)
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
