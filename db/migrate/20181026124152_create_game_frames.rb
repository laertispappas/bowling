class CreateGameFrames < ActiveRecord::Migration[5.2]
  def change
    create_table :game_frames do |t|
      t.references :game, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
    end
  end
end
