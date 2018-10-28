class GameFactory
  EmptyUsersError = Class.new(StandardError)

  def self.create(users)
    game = Game.new
    ApplicationRecord.transaction do
      game.save!

      users = create_users!(users, game)

      raise ActiveRecord::Rollback if users.blank?

      users.each(&:create_frames!)
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
end
