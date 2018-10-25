class Game < ApplicationRecord
  has_many :frames

  def roll(pins)

  end

  def score
    frames.sum(&:score)
  end
end
