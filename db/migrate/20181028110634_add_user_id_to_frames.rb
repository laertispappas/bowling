class AddUserIdToFrames < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :user_id, :bigint, null: false
    add_foreign_key :frames, :users
  end
end
