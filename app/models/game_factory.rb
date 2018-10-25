class GameFactory
  def self.create!
    ApplicationRecord.transaction do
      Game.create!.tap do |game|
        1.upto(10) { |_| game.frames.create! }
      end
    end
  end
end
