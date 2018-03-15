module SnapList
  class Handler
    def initialize(resp)
      @resp = resp
    end

    def bind(pattern)
      route = @resp.message.data.split("/")
      pattern = pattern.split("/")

      if route.count == pattern.count
        params = []

        match_result = pattern.each_with_index.map do |x, i|
          result = (x == route[i] || x[0] == ":")
          params << route[i] if x[0] == ":" && result # select only params
          result
        end

        if match_result.uniq == [true]
          puts "--\nBinding: #{pattern} \nRoute: #{route} \nParams: #{params}\n--"
          @bind_result = yield *params
        end
      end

      return
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
