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

  # true when the user has completed all his frames
  #
  def completed?
    !frames.any?(&:active?)
  end

  def create_frames!
    current_total_frames = frames.count
    return if current_total_frames == MAX_FRAMES_SIZE

    previous_frame = frames.last
    new_frame = if current_total_frames == MAX_FRAMES_SIZE - 1
                  LastFrame.create!(user: self)
                else
                  NormalFrame.create(user: self)
                end

    previous_frame&.update!(next_frame: new_frame)
    create_frames!
  end
end
