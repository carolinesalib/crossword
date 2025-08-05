class Clue < ApplicationRecord
  belongs_to :puzzle

  validates :number, presence: true, numericality: { greater_than: 0 }
  validates :direction, presence: true, inclusion: { in: %w[across down] }
  validates :row, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :col, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :answer, presence: true
  validates :clue_text, presence: true

  def across?
    direction == "across"
  end

  def down?
    direction == "down"
  end
end
