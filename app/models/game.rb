class Game < ApplicationRecord
  GameCompleteError = Class.new(StandardError)
  has_many :game_frames

  class OnFrameCompleted
    attr_reader :game
    def initialize(game)
      @game = game
    end

    def call
      next_game_frame = game.current_player.game_frame.next_game_frame
      if next_game_frame.present?
        game.current_player.game_frame.update!(active: false)
        next_game_frame.update!(active: true)
      end
    end
  end

  def roll(pins)
    raise GameCompleteError, 'Game has finished' unless current_player_game_frame.present?

    current_active_frame.roll(pins, on_frame_complete: OnFrameCompleted.new(self))
  end

  def score
    current_player_game_frame.frames.sum(&:score)
  end

  def create_game_frames!(user)
    is_active = game_frames.size.zero?
    game_frames.create!(user: user, active: is_active).add_frames!
    update_next_game_frame_id!
  end

  def current_player
    current_player_game_frame.user
  end

  private

  def current_active_frame
    current_player_game_frame.frames.find(&:active?)
  end

  def current_player_game_frame
    game_frames.find_by(active: true)
  end

  def update_next_game_frame_id!
    previous = game_frames[0]
    game_frames[1..-1].each do |next_game_frame|
      previous.update!(next_game_frame: next_game_frame)
      previous = next_game_frame
    end
  end
end
