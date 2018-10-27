class AddGameFrameIdToFrames < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :game_frame_id, :bigint, null: false
    add_foreign_key :frames, :game_frames
  end
end
