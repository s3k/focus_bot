module SnapList
  module Handler
    class Callback < Base
      def call
        bind "edit/done/:id" do |id|
          tasks.where(id: id).first&.update_attributes(done: true)
          list_result
        end

        bind "edit/not_done/:id" do |id|
          tasks.where(id: id).first&.update_attributes(done: false)
          list_result
        end

        bind "edit/post/:id" do |id|
          kb = markup do
            [ button(text: "Отмена", callback_data: "cancel") ]
          end

          user.update_attributes(context: :edit_task, payload: id)
          send(text: "Отправьте название задачи", reply_markup: kb)
        end

        bind "edit/:id" do |id|
          kb = markup do
            [ 
              button(text: "Отменить выполнение", callback_data: "edit/not_done/#{id}"),
              button(text: "Редактировать", callback_data: "edit/post/#{id}"),
              button(text: "Удалить", callback_data: "delete/#{id}"),
              button(text: "Отмена", callback_data: "cancel")
            ]
          end

          task = Task.find_by(id: id)
          send(text: "*Таск:* #{task.name}", reply_markup: kb, parse_mode: :markdown)
        end

        bind "delete/:id" do |id|
          tasks.where(id: id).first&.delete
          list_result("*Таск удален. Текущий список дел:*")
        end

        bind "new_task" do
          kb = markup do
            [ button(text: "Отмена", callback_data: "cancel") ]
          end

          user.update_attributes(context: :new_task, payload: nil)
          send(text: "*Как назвать задачу?*", reply_markup: kb, parse_mode: :markdown)
        end

        bind "done" do
          kb = markup do
            tasks.not_done.map{ |task|
              button(text: task.name, callback_data: "edit/done/#{task.id}")
            }.append( button(text: "Отмена", callback_data: "cancel") )
          end

          send(text: "*Выберите таск:*", reply_markup: kb, parse_mode: :markdown)
        end

        bind "edit_tasks" do
          kb = markup do
            user.tasks.map{ |task|
              button(text: task.name, callback_data: "edit/#{task.id}")
            }.append( button(text: "Отмена", callback_data: "cancel") )
          end

          send(text: "*Выберите таск:*", reply_markup: kb, parse_mode: :markdown)
        end

        bind "cancel" do
          user.update_attributes(context: nil)
          list_result("*Список текущих задач:*")
        end
      end
    end
  end
end
