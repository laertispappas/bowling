class RemoveGameIdFromFrames < ActiveRecord::Migration[5.2]
  def up
    remove_column :frames, :game_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
