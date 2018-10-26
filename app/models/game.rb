class Game < ApplicationRecord
  GameCompleteError = Class.new(StandardError)

  has_many :game_frames

  def roll(pins)
    raise GameCompleteError, 'Game has finished' unless current_active_frame.present?
    current_active_frame.roll(pins)
  end

  def score
    current_player_game_frame.frames.sum(&:score)
  end

  private

  def current_active_frame
    current_player_game_frame.frames.find(&:active?)
  end

  def current_player_game_frame
    game_frames.find_by(active: true)
  end
end
