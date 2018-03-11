module SnapList
  module Handler
    class Message < Base
      def initialize(resp)
        @resp = resp
      end

      def call
        name = @resp.message.from.first_name

        case @resp.message.text
        when "/start"
          create_user

          kb = markup do
            [ button(text: "Добавить таск", callback_data: "new_task") ]
          end

          text = "Привет #{name}! \n\nЭто простой Todo бот, который позволит тебе не забывать про свои дела.\n\n"
          send(text: text, reply_markup: kb)

        when "/list"
          list_result

        else
          context_handler
        end
      end

      private

      def context_handler
        case user.context&.to_sym
        when :new_task
          user.tasks.create(name: @resp.message.text)
          list_result("*Задача добавлена. Текущий список дел:*")
          user.update_attributes(context: nil)

        when :edit_task
          user.tasks.where(id: user.payload).first.update_attributes(name: @resp.message.text)
          list_result("*Задача обновлена. Текущий список дел:*")
          user.update_attributes(context: nil, payload: nil)

        else
          list_result
        end
      end
    end
  end
end
