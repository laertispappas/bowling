class AddNextFrameToFrames < ActiveRecord::Migration[5.2]
  def up
    add_column :frames, :next_frame_id, :bigint
    add_foreign_key :frames, :frames, column: :next_frame_id
  end

  def down
    remove_foreign_key :frames, :frames
    remove_column :frames, :next_frame
  end
end
