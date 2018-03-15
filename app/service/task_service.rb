class TaskService < ApplicationHandler
  def ask_create
    kb = markup do
      [ button(text: "Отмена", callback_data: "cancel") ]
    end

    user.update_attributes(context: "task/create", payload: nil)
    say(text: "*Как назвать задачу?*", reply_markup: kb, parse_mode: :markdown)
  end

  def create
    user.tasks.create(name: @resp.message.text)
    user.update_attributes(context: nil)

    UserService.new(@resp).list("*Задача добавлена. Текущий список дел:*")
  end
end
