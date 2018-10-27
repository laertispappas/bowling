class GameFactory
  EmptyUsersError = Class.new(StandardError)

  def self.create(users)
    ApplicationRecord.transaction do
      users = create_users!(users)
      return false if users.blank?

      game = Game.create!

      users.each do |user|
        game.create_game_frames!(user)
      end

      game
    end
  rescue ActiveRecord::RecordInvalid => _ex
    return false
  end

  # Not sure if we need to check the maximum allowed users count
  #
  def self.create_users!(users)
    users.map do |user|
      User.create!(name: user[:name])
    end
  end

  private_class_method :create_users!
end
