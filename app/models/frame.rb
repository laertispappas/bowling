class Frame < ApplicationRecord
  MAX_PINS_SCORE = 10
  MAX_ROLLS_COUNT = 2
  RollError = Class.new(StandardError)

  belongs_to :game_frame
  belongs_to :next_frame, class_name: 'Frame', foreign_key: :next_frame_id, optional: true
  has_many :rolls

  default_scope { order(id: :asc) }

  def roll(pins, on_frame_complete: -> {})
    with_lock do
      return Result::Error.new('Cannot roll on a completed frame') unless active?

      rolls.create!(pins: pins)
      on_frame_complete.call unless active?

      Result::Success.new
    end

  rescue ActiveRecord::RecordInvalid => _ex
    Result::Error.new(_ex)
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
    rolls.size < MAX_ROLLS_COUNT
  end
end
