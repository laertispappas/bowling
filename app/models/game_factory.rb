class GameFactory
  MAX_FRAMES_SIZE = 10

  def self.create!(users)
    ApplicationRecord.transaction do
      Game.create!.tap do |game|
        users = users.map do |user|
          User.create!(name: user[:name])
        end

        users.each_with_index do |user, index|
          GameFrame.create!(game: game, user: user, active: index == 0).tap do |game_frame|
            previous_frame = NormalFrame.create!(game_frame: game_frame)
            (MAX_FRAMES_SIZE - 1).times do |i|
              new_frame = if i == MAX_FRAMES_SIZE - 2
                            LastFrame.create!(game_frame: game_frame)
                          else
                            NormalFrame.create!(game_frame: game_frame)
                          end

              previous_frame.update!(next_frame: new_frame)
              previous_frame = new_frame
            end
          end
        end
      end
    end
  end
end
