require 'rails_helper'

describe GameFactory, type: :model do
  subject { described_class }

  describe '.create' do
    it 'creates a game with 10 frames' do
      game = subject.create

      expect(game).to be_persisted
      expect(game.frames.count).to eq 10
      expect(game.score).to be_zero
    end
  end
end
