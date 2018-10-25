class CreateRolls < ActiveRecord::Migration[5.2]
  def change
    create_table :rolls do |t|
      t.references :frame, foreign_key: true, null: false
      t.integer :pins, null: false
    end
  end
end
