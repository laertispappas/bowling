class Game < ApplicationRecord
  has_many :game_frames
  has_many :players,
           through: :game_frames,
           class_name: 'User',
           foreign_key: :user_id,
           source: :user

  class OnFrameCompleted
    # Keep current active game frame in sync
    #
    attr_reader :current_active_game_frame

    def initialize(current_active_game_frame)
      @current_active_game_frame = current_active_game_frame
    end

    def call
      next_game_frame = current_active_game_frame.next_game_frame

      if next_game_frame.present?
        current_active_game_frame.update!(active: false)
        next_game_frame.update!(active: true)
      end

      # all frames completed for the current user
      unless current_active_game_frame.active?
        current_active_game_frame.update!(active: false)
      end
    end
  end

  def roll(pins)
    unless current_active_game_frame.present?
      return Result::Error.new('Game has finished')
    end

    current_active_frame.with_lock do
      current_active_frame
        .roll(pins, on_frame_complete: OnFrameCompleted.new(current_active_game_frame))
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
    link_game_frames!
  end

  def current_player
    current_active_game_frame&.user
  end

  def current_active_frame
    current_active_game_frame&.frames&.find(&:active?)
  end

  def completed?
    !game_frames.all?(&:active?)
  end

  def winner
    return unless completed?

    players.map { |user| [user.name, score(user)] }
      .max_by { |_name, score| score }
      .first
  end

  private

  def current_active_game_frame
    game_frames.find_by(active: true)
  end

  def link_game_frames!
    previous, _next = game_frames.last(2)
    return unless _next

    previous.update!(next_game_frame: _next)

    # cyclic list only if we have more than 1 users
    if multiple_players?
      _next.next_game_frame = game_frames[0]
      _next.save!
    end
  end

  def multiple_players?
    game_frames.size > 1
  end
end
