class CreatePuzzles < ActiveRecord::Migration[8.0]
  def change
    create_table :puzzles do |t|
      t.string :title
      t.text :description
      t.integer :grid_size

      t.timestamps
    end
  end
end
