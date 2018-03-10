class CreateTasks < ActiveRecord::Migration[5.0]
  def self.up
    create_table :tasks do |t|
      t.integer :user_id
      t.integer :goal_id
      t.string :name
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
