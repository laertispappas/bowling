class GameFactory
  MAX_FRAMES_SIZE = 10

  def self.create!
    ApplicationRecord.transaction do
      Game.create!.tap do |game|
        # first frame
        previous_frame = NormalFrame.create!(game: game)

        (MAX_FRAMES_SIZE - 1).times do |i|
          new_frame = if i == MAX_FRAMES_SIZE - 2
                        LastFrame.create!(game: game)
                      else
                        NormalFrame.create!(game: game)
                      end

          previous_frame.update!(next_frame: new_frame)
          previous_frame = new_frame
        end
      end
    end
  end
end
