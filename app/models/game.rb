class Game < ApplicationRecord
  has_many :players,
           class_name: 'User'

  def score(user)
    user.score
  end

  def roll(pins)
    with_lock do
      return Result::Error.new('Game has finished') if completed?

      current_player.roll(pins).and_then do
        Result::Success.new(self)
      end
    end
  end

  def current_player
    return if players.all?(&:game_completed?)

    players.min_by(&:completed_frames)
  end

  def current_active_frame
    current_player&.active_frame
  end

  def completed?
    players.all?(&:game_completed?)
  end

  def winner
    return unless completed?

    players.map { |user| [user.name, score(user)] }
      .max_by { |_name, score| score }
      .first
  end

  private
end
