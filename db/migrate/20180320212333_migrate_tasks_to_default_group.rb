require_relative "./../../app/model/user"
require_relative "./../../app/model/task"
require_relative "./../../app/model/group"

class MigrateTasksToDefaultGroup < ActiveRecord::Migration[5.0]
  def change
    User.all.each do |user|
      tasks = Task.where(user_id: user.id)
      user.tasks << tasks
      tasks.update_all(user_id: nil)
    end
  end
end
