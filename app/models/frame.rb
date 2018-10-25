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
    bonus = if strike?
              next_frame.rolls.sum(&:score)
            elsif spare?
              next_frame.rolls.first.score
            else
              0
            end
    rolls.sum(&:pins) + bonus
  end

  def active?
    return false if strike? || spare?
    rolls.empty? || !rolls_completed?
  end

  private

  def rolls_completed?
    rolls.size == MAX_ROLLS_COUNT
  end

  def strike?
    rolls.size == 1 && rolls.first.pins == MAX_PINS_SCORE
  end

  def spare?
    rolls.size == MAX_ROLLS_COUNT && rolls.sum(&:pins) == MAX_PINS_SCORE
  end
end
