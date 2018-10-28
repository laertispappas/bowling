class AddGameIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :game_id, :bigint, null: false
    add_foreign_key :users, :games
  end
end
