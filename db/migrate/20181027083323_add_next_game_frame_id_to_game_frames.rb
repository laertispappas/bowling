class AddNextGameFrameIdToGameFrames < ActiveRecord::Migration[5.2]
  def change
    add_column :game_frames, :next_game_frame_id, :bigint
    add_foreign_key :game_frames, :game_frames, column: :next_game_frame_id
  end
end
