class UserService < ApplicationHandler
  def start
    user = create_user

    kb = markup do
      [ button(text: "Добавить таск", callback_data: "task/ask/create") ]
    end

    text = "Привет #{user.first_name}! \n\nЭто простой Todo бот, который позволит тебе не забывать про свои дела.\n\n"
    say(text: text, reply_markup: kb)
  end

  def list(name="*Список дел:*")
    diamond = "\xF0\x9F\x94\xB9"
    square = "\xE2\x97\xBD"

    kb = markup do
      [ [button(text: "Добавить", callback_data: "task/ask/create"),
         button(text: "Изменить", callback_data: "task/list")],
      [ button(text: "Готово", callback_data: "done")],
      ]
    end

    result = user.tasks.order(created_at: :desc).map{ |task|
      task.done ? "#{diamond} #{task.name}" : "#{square} #{task.name}"
    }.join("\n")

    say(text: "#{name}\n\n#{result}", parse_mode: :markdown, reply_markup: kb)
  end

  private

  def create_user
    tg_user = @resp.message.from.to_h
    tg_user[:tg_id] = tg_user.delete(:id)

    User.create_with(tg_user).find_or_create_by(tg_id: tg_user[:tg_id])
  end
end
