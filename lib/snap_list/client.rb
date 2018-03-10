module SnapList
  class Client
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

    def message_handler(resp)
      name = resp.message.from.first_name

      case resp.message.text
      when "/start"
        kb = markup do
          [
            button(text: "Добавить таск", callback_data: "new_task"),
          ]
        end

        text = "Привет #{name}! \n\nЭто простой Todo бот, который позволит тебе не забывать про свои дела.\n\n"

        send(resp, text: text, reply_markup: kb)

      when "/stop"
        send(resp, text: "Bye, #{name}")

      when "/add"
        send(resp, text: "Просто напишите название таска")

      when "/keys"
        question = 'London is a capital of which country?'
        answers = keyboard([%w(A B), %w(C D)])
        send(resp, text: question, reply_markup: answers)

      when "/menu"
        kb = markup do
          [
            button(text: "Все таски", callback_data: 'touch'),
            button(text: "Таски на сегодня", callback_data: 'touch'),
            button(text: "Новый таск", callback_data: 'touch'),
            button(text: "Новая группа", callback_data: 'touch'),
            button(text: "Отчет за вчера", callback_data: 'touch'),
            button(text: "Отчет за неделю", callback_data: 'touch'),
          ]
        end

        send(resp, text: "Make a choice", reply_markup: kb)
      else
        send(resp, text: "Хорошо, ты написал:\n#{resp.message.text}")
      end
    end

    def cb_handler(resp)
      case resp.message.data.to_sym
      when :new_task
        send(resp, text: "Как назвать задачу?")
      end
    end

    def inline_handler(resp)
      # pp resp.message
    end

    def event_handler(resp)
      case resp.message
      when Telegram::Bot::Types::InlineQuery
        inline_handler(resp)

      when Telegram::Bot::Types::Message
        message_handler(resp)

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
