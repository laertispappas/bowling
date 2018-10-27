class AddActiveToGameFrames < ActiveRecord::Migration[5.2]
  def change
    add_column :game_frames, :active, :boolean, null: false, default: false
  end
end
