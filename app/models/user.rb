class User < ApplicationRecord
  MAX_FRAMES_SIZE = 10

  has_many :frames
  belongs_to :game

  validates_presence_of :name

  # We need an index column here but for now primary keys will work for now
  #
  default_scope { order(id: :asc) }

  def score
    frames.sum(&:score)
  end

  def roll(pins)
    active_frame
      .roll(pins)
      .and_then do |_data|
      Result::Success.new
    end
  end

  def active_frame
    frames.find(&:active?)
  end

  def completed_frames
    frames.size - frames.select(&:active?).size
  end

  def game_completed?
    frames.none?(&:active?)
  end
end
