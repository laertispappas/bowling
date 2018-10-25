class Game < ApplicationRecord
  has_many :frames

  def roll(pins)
    current_frame.roll(pins)
  end

  def score
    frames.sum(&:score)
  end

  private

  def current_frame
    frames.find(&:active?)
  end
end
