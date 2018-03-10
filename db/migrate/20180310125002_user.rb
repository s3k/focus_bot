class User < ActiveRecord::Migration[5.0]
  def up
    create_table :users do |t|
      t.integer :tg_id
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :language_code
      t.boolean :is_bot
      t.string :context

      t.timestamps
    end

    add_index :users, :username
    add_index :users, :tg_id, unique: true
  end

  def down
    drop_table :users
  end
end
