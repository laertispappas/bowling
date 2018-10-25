class Frame < ApplicationRecord
  MAX_PINS_SCORE = 10
  MAX_ROLLS_COUNT = 2
  RollError = Class.new(StandardError)

  belongs_to :game
  belongs_to :next_frame, class_name: 'Frame', foreign_key: :next_frame_id, optional: true
  has_many :rolls

  default_scope { order(id: :asc) }

  def roll(pins)
    raise RollError, 'Cannot roll on a completed frame' unless active?
    rolls.create!(pins: pins)
  end

  def score
    rolls.sum(&:score) + calculate_bonus
  end

  def active?
    return false if strike? || spare?
    more_rolls?
  end

  protected

  def strike?
    rolls.present? && rolls.first.score == MAX_PINS_SCORE
  end

  private

  def calculate_bonus
    raise NotImplementedError, 'Abstract method'
  end

  def spare?
    rolls.size == MAX_ROLLS_COUNT && rolls.sum(&:score) == MAX_PINS_SCORE
  end

  def more_rolls?
    rolls.empty? || rolls.size < MAX_ROLLS_COUNT
  end
end
