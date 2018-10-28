class GameFactory
  EmptyUsersError = Class.new(StandardError)

  def self.create(users)
    game = Game.new
    ApplicationRecord.transaction do
      game.save!

      users = create_users!(users, game)

      raise ActiveRecord::Rollback if users.blank?

      users.each(&method(:create_frames!))
    end
    game
  rescue ActiveRecord::RecordInvalid => _ex
    game
  end

  # Not sure if we need to check the maximum allowed users count
  #
  def self.create_users!(users, game)
    users.map do |user|
      User.create!(name: user[:name], game: game)
    end
  end

  private_class_method :create_users!

  def self.create_frames!(user)
    current_total_frames = user.frames.count
    return if current_total_frames == User::MAX_FRAMES_SIZE

    previous_frame = user.frames.last
    new_frame = if current_total_frames == User::MAX_FRAMES_SIZE - 1
                  LastFrame.create!(user: user)
                else
                  NormalFrame.create(user: user)
                end

    previous_frame&.update!(next_frame: new_frame)
    create_frames!(user)
  end
  private_class_method :create_frames!
end
