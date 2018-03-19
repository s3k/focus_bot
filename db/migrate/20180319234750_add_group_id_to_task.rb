class AddGroupIdToTask < ActiveRecord::Migration[5.0]
  def up
    add_column :tasks, :group_id, :integer
  end
  def down
    remove_column :tasks, :group_id
  end
end
