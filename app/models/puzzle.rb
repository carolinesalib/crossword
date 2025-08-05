class Puzzle < ApplicationRecord
  has_many :clues, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :grid_size, presence: true, numericality: { greater_than: 0 }

  def across_clues
    clues.where(direction: "across").order(:number)
  end

  def down_clues
    clues.where(direction: "down").order(:number)
  end
end
