class GameFrame < ApplicationRecord
  MAX_FRAMES_SIZE = 10

  has_many :frames
  belongs_to :game
  belongs_to :user
  belongs_to :next_game_frame, optional: true, class_name: 'GameFrame', foreign_key: :next_game_frame_id

  default_scope { order(id: :asc) }

  def score
    frames.sum(&:score)
  end

  def add_frames!
    current_total_frames = frames.count
    return if current_total_frames == MAX_FRAMES_SIZE

    previous_frame = frames.last
    new_frame = if current_total_frames == MAX_FRAMES_SIZE - 1
                  LastFrame.create!(game_frame: self)
                else
                  NormalFrame.create(game_frame: self)
                end

    previous_frame&.update!(next_frame: new_frame)
    add_frames!
  end

  def active?
    frames.any?(&:active?)
  end
end
