class Frame < ApplicationRecord
  belongs_to :game
  has_many :rolls

  def score
    rolls.sum(&:pins)
  end
end
