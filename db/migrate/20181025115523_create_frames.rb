class CreateFrames < ActiveRecord::Migration[5.2]
  def change
    create_table :frames do |t|
      t.references :game, null: false
    end

    add_foreign_key :frames, :games, column: :game_id
  end
end
