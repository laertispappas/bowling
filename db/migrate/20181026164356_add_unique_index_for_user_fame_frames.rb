class AddUniqueIndexForUserFameFrames < ActiveRecord::Migration[5.2]
  def change
    add_index :game_frames, [:game_id, :user_id], unique: true
  end
end
