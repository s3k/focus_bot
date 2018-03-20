class GroupService < ApplicationHandler
  def list
    kb = markup do
      user.groups.map do |group|
        name = group.name
        tasks_count = group.tasks.count

        unless group.id == user.default_group_id
          button(text: "#{name} (#{tasks_count})", callback_data: "group/set_active/#{group.id}")
        end
      end + [

        button(text: "Группа по умолчанию (#{user.default_group.tasks.count})",
               callback_data: "group/set_active/#{user.default_group_id}"),
        button(text: "Создать группу", callback_data: "group/ask/create"),
        button(text: "Удалить группу", callback_data: "group/ask/delete"),
        button(text: "Отмена", callback_data: "common/cancel")
      ]
    end

    say(text: "*Список групп:*\nКликните, чтобы сменить группу",
        parse_mode: :markdown, reply_markup: kb)
  end

  def ask_delete
    kb = markup do
      user.groups.map do |group|
        name = group.name
        tasks_count = group.tasks.count

        unless group.id == user.default_group_id
          button(text: "#{name} (#{tasks_count})", callback_data: "group/delete/#{group.id}")
        end
      end << button(text: "Отмена", callback_data: "common/cancel")
    end

    say(text: "*Список групп:*\nКликните, чтобы удалить группу",
        parse_mode: :markdown, reply_markup: kb)
  end

  def delete
    user.groups.find_by(id: params[:id]).destroy
    user.update_attributes(current_group_id: user.default_group_id)
    notify_result("Активная группа: #{user.current_group.name}")
  end

  def ask_create
    kb = markup do
      [ button(text: "Отмена", callback_data: "common/cancel") ]
    end

    user.update_attributes(context: "group/create")

    say(text: "*Как назвать группу?*\nПросто отправьте как назвать группу.",
        parse_mode: :markdown, reply_markup: kb)
  end

  def create
    user.groups.create(name: @resp.message.text)
    user.update_attributes(context: nil, payload: nil)
    notify_result("Группа добавлена. Сменить ее можно командой /groupList")
  end

  def set_active
    user.update_attributes(current_group_id: params[:id])
    notify_result("Активная группа: #{user.current_group.name}")
  end
end
