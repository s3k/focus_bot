class TaskService < ApplicationHandler
  def ask_create
    kb = markup do
      [ button(text: "Отмена", callback_data: "common/cancel") ]
    end

    user.update_attributes(context: "task/create", payload: nil)
    say(text: "*Как назвать задачу?*\nПросто отправьте мне название задачи.", 
        reply_markup: kb, parse_mode: :markdown)
  end

  def create
    user.tasks.create(name: @resp.message.text)
    user.update_attributes(context: nil)

    notify_result("Задача добавлена")
  end

  def ask_done
    kb = markup do
      user.tasks.not_done.order(created_at: :desc).map{ |task|
        button(text: task.name, callback_data: "task/done/#{task.id}")
      }.append( button(text: "Отмена", callback_data: "common/cancel") )
    end

    say(text: "*Выберите таск:*", reply_markup: kb, parse_mode: :markdown)
  end

  def done
    user.tasks.where(id: params[:id]).first&.update_attributes(done: true)
    notify_result("Готово")
  end

  def not_done
    user.tasks.where(id: params[:id]).first&.update_attributes(done: false)
    notify_result("Готово")
  end

  def list
    kb = markup do
      user.tasks.order(created_at: :desc).map{ |task|
        button(text: task.name, callback_data: "task/change/#{task.id}")
      }.append( button(text: "Отмена", callback_data: "common/cancel") )
    end

    say(text: "*Выберите таск:*", reply_markup: kb, parse_mode: :markdown)
  end

  def change
    id = params[:id]

    kb = markup do
      [
        button(text: "Отменить выполнение", callback_data: "task/not_done/#{id}"),
        button(text: "Редактировать", callback_data: "task/ask/update/#{id}"),
        button(text: "Удалить", callback_data: "task/delete/#{id}"),
        button(text: "Отмена", callback_data: "common/cancel")
      ]
    end

    task = user.tasks.find_by(id: id)
    say(text: "*Таск:* #{task.name}", reply_markup: kb, parse_mode: :markdown)
  end

  def ask_update
    kb = markup do
      [ button(text: "Отмена", callback_data: "common/cancel") ]
    end

    user.update_attributes(context: "task/update", payload: params[:id])
    say(text: "*Как назвать задачу?*\nПросто отправьте как переименовать задачу.", reply_markup: kb, parse_mode: :markdown)
  end

  def update
    user.tasks.where(id: user.payload).first
      .update_attributes(name: @resp.message.text)
    user.update_attributes(context: nil, payload: nil)

    notify_result("Задача обновлена")
  end

  def delete
    user.tasks.where(id: params[:id]).first&.delete
    notify_result("Таск удален")
  end
end
