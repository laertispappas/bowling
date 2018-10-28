class RemoveGameFrames < ActiveRecord::Migration[5.2]
  def up
    remove_foreign_key :frames, :game_frames
    remove_column :frames, :game_frame_id
    drop_table :game_frames
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
