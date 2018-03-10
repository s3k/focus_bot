module SnapList
  module Handler
    def create_user(resp)
      user = resp.message.from.to_h
      user[:tg_id] = user[:id]
      user.delete(:id)

      User.create_with(user).find_or_create_by(tg_id: user[:tg_id])
    end

    def list_result(resp, name="*Список дел:*")
      user = User.find_by(tg_id: resp.message.from.id)

      kb = markup do
        [ [button(text: "Добавить", callback_data: "new_task"),
           button(text: "Изменить", callback_data: "edit_tasks")],
        [ button(text: "Готово", callback_data: "done")],
        ]
      end

      diamond = "\xF0\x9F\x94\xB9"
      square = "\xE2\x97\xBD"

      tasks = user.tasks.order(created_at: :desc).map{ |task| task.done ? "#{diamond} #{task.name}" : "#{square} #{task.name}" }.join("\n")
      send(resp, text: "#{name}\n\n#{tasks}", parse_mode: :markdown, reply_markup: kb)
    end

    # Commands
    def message_handler(resp)
      user = User.find_by(tg_id: resp.message.from.id)
      name = resp.message.from.first_name

      case resp.message.text
      when "/start"
        create_user(resp)

        kb = markup do
          [ button(text: "Добавить таск", callback_data: "new_task") ]
        end

        text = "Привет #{name}! \n\nЭто простой Todo бот, который позволит тебе не забывать про свои дела.\n\n"
        send(resp, text: text, reply_markup: kb)

      when "/stop"
        send(resp, text: "Bye, #{name}")

      when "/list"
        list_result(resp)

      else
        context_handler(resp)
      end
    end

    # Action results
    def context_handler(resp)
      user = User.find_by(tg_id: resp.message.from.id)

      case user.context&.to_sym
      when :new_task
        user.tasks.create(name: resp.message.text)
        list_result(resp, "*Задача добавлена. Текущий список дел:*")
        user.update_attributes(context: nil)

      when :edit_task
        user.tasks.where(id: user.payload).first.update_attributes(name: resp.message.text)
        list_result(resp, "*Задача обновлена. Текущий список дел:*")
        user.update_attributes(context: nil, payload: nil)

      else
        list_result(resp)
      end
    end

    # Btn actions
    def cb_handler(resp)
      user = User.find_by(tg_id: resp.message.from.id)

      case resp.message.data
      when /edit\/done\/([0-9]*)/
        user.tasks.where(id: $1).first&.update_attributes(done: true)
        list_result(resp)

      when /edit\/not_done\/([0-9]*)/
        user.tasks.where(id: $1).first&.update_attributes(done: false)
        list_result(resp)

      when /edit\/post\/([0-9]*)/
        kb = markup do
          [ button(text: "Отмена", callback_data: "cancel") ]
        end

        user.update_attributes(context: :edit_task, payload: $1)
        send(resp, text: "Как назвать задачу?", reply_markup: kb)

      when /edit\/([0-9]*)/
        kb = markup do
          [ 
            button(text: "Отменить выполнение", callback_data: "edit/not_done/#{$1}"),
            button(text: "Редактировать", callback_data: "edit/post/#{$1}"),
            button(text: "Удалить", callback_data: "delete/#{$1}"),
            button(text: "Отмена", callback_data: "cancel")
          ]
        end

        task = Task.find_by(id: $1)
        send(resp, text: "*Таск:* #{task.name}", reply_markup: kb, parse_mode: :markdown)

      when /delete\/([0-9]*)/
        user.tasks.where(id: $1).first&.delete
        list_result(resp, "*Таск удален. Текущий список дел:*")

      when "new_task"
        kb = markup do
          [ button(text: "Отмена", callback_data: "cancel") ]
        end

        user.update_attributes(context: :new_task, payload: nil)
        send(resp, text: "*Как назвать задачу?*", reply_markup: kb, parse_mode: :markdown)

      when "done"
        kb = markup do
          user.tasks.not_done.map{ |task| 
            button(text: task.name, callback_data: "edit/done/#{task.id}")
          }.append( button(text: "Отмена", callback_data: "cancel") )
        end

        send(resp, text: "*Выберите таск:*", reply_markup: kb, parse_mode: :markdown)

      when "edit_tasks"
        kb = markup do
          user.tasks.map{ |task| 
            button(text: task.name, callback_data: "edit/#{task.id}")
          }.append( button(text: "Отмена", callback_data: "cancel") )
        end

        send(resp, text: "*Выберите таск:*", reply_markup: kb, parse_mode: :markdown)

      when "cancel"
        user.update_attributes(context: nil)
        list_result(resp, "*Список текущих задач:*")
      end
    end

    def inline_handler(resp)
    end
  end
end

