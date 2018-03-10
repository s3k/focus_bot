module SnapList
  class HandlerBase
    #
    # Model helpers
    #

    def user
      @user ||= User.find_by(tg_id: @resp.message.from.id)
    end

    def create_user(resp)
      tg_user = resp.message.from.to_h
      tg_user[:tg_id] = user[:id]
      tg_user.delete(:id)

      User.create_with(tg_user).find_or_create_by(tg_id: tg_user[:tg_id])
    end

    #
    # Telegram helpers
    #

    def list_result(name="*Список дел:*")
      kb = markup do
        [ [button(text: "Добавить", callback_data: "new_task"),
           button(text: "Изменить", callback_data: "edit_tasks")],
        [ button(text: "Готово", callback_data: "done")],
        ]
      end

      diamond = "\xF0\x9F\x94\xB9"
      square = "\xE2\x97\xBD"

      tasks = user.tasks.order(created_at: :desc).map{ |task| task.done ? "#{diamond} #{task.name}" : "#{square} #{task.name}" }.join("\n")

      send(text: "#{name}\n\n#{tasks}", parse_mode: :markdown, reply_markup: kb)
    end

    def send(opt={})
      case @resp.message
      when Telegram::Bot::Types::CallbackQuery
        chat_id = @resp.message.message.chat.id
      else
        chat_id = @resp.message.chat.id
      end

      opt.merge!({ chat_id: chat_id })
      @resp.bot.api.send_message(opt)
    end

    def button(opt={})
      Telegram::Bot::Types::InlineKeyboardButton.new(opt)
    end

    def markup
      Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: yield)
    end
  end
end
