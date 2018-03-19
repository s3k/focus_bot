class AddGroupsModel < ActiveRecord::Migration[5.0]
  def up
    create_table :groups do |t|
      t.string :name
      t.timestamps
    end
  end

  def down
    drop_table :groups
  end
end
