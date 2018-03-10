module SnapList
  class CallbackHandler < HandlerBase
    def initialize(resp)
      @resp = resp
    end

    def call
      case @resp.message.data
      when /edit\/done\/([0-9]*)/
        user.tasks.where(id: $1).first&.update_attributes(done: true)
        list_result

      when /edit\/not_done\/([0-9]*)/
        user.tasks.where(id: $1).first&.update_attributes(done: false)
        list_result

      when /edit\/post\/([0-9]*)/
        kb = markup do
          [ button(text: "Отмена", callback_data: "cancel") ]
        end

        user.update_attributes(context: :edit_task, payload: $1)
        send(text: "Отправьте название задачи", reply_markup: kb)

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
        send(text: "*Таск:* #{task.name}", reply_markup: kb, parse_mode: :markdown)

      when /delete\/([0-9]*)/
        user.tasks.where(id: $1).first&.delete
        list_result("*Таск удален. Текущий список дел:*")

      when "new_task"
        kb = markup do
          [ button(text: "Отмена", callback_data: "cancel") ]
        end

        user.update_attributes(context: :new_task, payload: nil)
        send(text: "*Как назвать задачу?*", reply_markup: kb, parse_mode: :markdown)

      when "done"
        kb = markup do
          user.tasks.not_done.map{ |task| 
            button(text: task.name, callback_data: "edit/done/#{task.id}")
          }.append( button(text: "Отмена", callback_data: "cancel") )
        end

        send(text: "*Выберите таск:*", reply_markup: kb, parse_mode: :markdown)

      when "edit_tasks"
        kb = markup do
          user.tasks.map{ |task| 
            button(text: task.name, callback_data: "edit/#{task.id}")
          }.append( button(text: "Отмена", callback_data: "cancel") )
        end

        send(text: "*Выберите таск:*", reply_markup: kb, parse_mode: :markdown)

      when "cancel"
        user.update_attributes(context: nil)
        list_result("*Список текущих задач:*")
      end
    end
  end
end
