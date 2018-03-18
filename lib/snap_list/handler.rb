module SnapList
  class Handler
    def initialize(resp)
      @resp = resp
    end

    def params
      @resp.params
    end

    def say(opt={})
      if @resp.message.is_a? Telegram::Bot::Types::CallbackQuery
        qid = @resp.message.id
        chat_id = @resp.message.message.chat.id
        answer = { callback_query_id: qid }

        @resp.bot.api.answer_callback_query(answer)
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
