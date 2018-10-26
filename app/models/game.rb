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

  def create_game_frames!(user)
    is_active = game_frames.size.zero?
    game_frames
      .create!(user: user, active: is_active)
      .add_frames!
  end

  private

  def current_active_frame
    current_player_game_frame.frames.find(&:active?)
  end

  def current_player_game_frame
    game_frames.find_by(active: true)
  end
end
