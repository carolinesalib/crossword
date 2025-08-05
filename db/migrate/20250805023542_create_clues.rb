class CreateClues < ActiveRecord::Migration[8.0]
  def change
    create_table :clues do |t|
      t.references :puzzle, null: false, foreign_key: true
      t.integer :number
      t.string :direction
      t.integer :row
      t.integer :col
      t.string :answer
      t.text :clue_text

      t.timestamps
    end
  end
end
