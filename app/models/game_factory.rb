class GameFactory
  MAX_FRAMES_SIZE = 10

  def self.create!
    ApplicationRecord.transaction do
      Game.create!.tap do |game|
        # first frame
        previous_frame = game.frames.create!

        (MAX_FRAMES_SIZE - 1).times do |i|
          new_frame = game.frames.create!
          previous_frame.update!(next_frame: new_frame)
          previous_frame = new_frame
        end
      end
    end
  end
end
