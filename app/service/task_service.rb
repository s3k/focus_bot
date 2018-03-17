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

    notify_result
  end

  def list
    kb = markup do
      user.tasks.map{ |task|
        button(text: task.name, callback_data: "task/change/#{task.id}")
      }.append( button(text: "Отмена", callback_data: "common/cancel") )
    end

    say(text: "*Выберите таск:*", reply_markup: kb, parse_mode: :markdown)
  end

  def update
    user.tasks.where(id: user.payload).first
      .update_attributes(name: @resp.message.text)
    user.update_attributes(context: nil, payload: nil)

    notify_result
  end

  private

  def notify_result
    UserService.new(@resp).list("*Задача добавлена. Текущий список дел:*")
  end
end
