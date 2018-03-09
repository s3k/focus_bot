class CreateTasks < ActiveRecord::Migration[5.0]
  def self.up
    create_table :tasks do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :tasks
  end
end
