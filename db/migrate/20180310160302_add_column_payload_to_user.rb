class AddColumnPayloadToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :payload, :string
  end
end
