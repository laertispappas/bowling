class GameFactory
  MAX_FRAMES_SIZE = 10

  def self.create!(users)
    ApplicationRecord.transaction do
      users = create_users!(users)
      game = Game.create!

      users.each do |user|
        game.create_game_frames!(user)
      end

      game
    end
  end

  def self.create_users!(users)
    users.map do |user|
      User.create!(name: user[:name])
    end
  end

  private_class_method :create_users!
end
