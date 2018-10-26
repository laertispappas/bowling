class GameFrame < ApplicationRecord
  MAX_FRAMES_SIZE = 10
  MaximumFramesReachedError = Class.new(StandardError)

  belongs_to :game
  belongs_to :user
  has_many :frames

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
end
