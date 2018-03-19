class AddCurrentGroupIdToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :current_group_id, :integer
  end
end
