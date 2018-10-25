class AddTypeToFrames < ActiveRecord::Migration[5.2]
  def change
    add_column :frames, :type, :string, null: false
  end
end
