class Game < ApplicationRecord
  GameCompleteError = Class.new(StandardError)

  has_many :frames

  def roll(pins)
    raise GameCompleteError, 'Game has finished' unless current_active_frame.present?
    current_active_frame.roll(pins)
  end

  def score
    frames.sum(&:score)
  end

  private

  def current_active_frame
    frames.find(&:active?)
  end
end
