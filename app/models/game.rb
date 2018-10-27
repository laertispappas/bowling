class Game < ApplicationRecord
  GameCompleteError = Class.new(StandardError)
  has_many :game_frames
  has_many :players,
           through: :game_frames,
           class_name: 'User',
           foreign_key: :user_id,
           source: :user

  class OnFrameCompleted
    # Keep current active game frame in sync
    #
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

      # all frames completed for the current user
      unless game.current_player.game_frame.frames.any?(&:active?)
        game.current_player.game_frame.update!(active: false)
      end
    end
  end

  def roll(pins)
    unless current_active_game_frame.present?
      return Result::Error.new('Game has finished')
    end

    current_active_frame.with_lock do
      current_active_frame
        .roll(pins, on_frame_complete: OnFrameCompleted.new(self))
        .and_then do |_data|
          Result::Success.new(self)
        end
    end
  end

  def score(user)
    user.game_frame.score
  end

  def create_game_frames!(user)
    is_active = game_frames.size.zero?
    game_frames.create!(user: user, active: is_active).add_frames!
    update_next_game_frame_id!
  end

  def current_player
    current_active_game_frame.user
  end

  def current_active_frame
    current_active_game_frame.frames.find(&:active?)
  end

  private

  def current_active_game_frame
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
