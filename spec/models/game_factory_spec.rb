require 'rails_helper'

describe GameFactory, type: :model do
  subject { described_class }

  describe '.create!' do
    let(:game) { subject.create! }
    it 'creates a game with 10 frames' do
      expect(game).to be_persisted
      expect(game.frames.count).to eq 10
      expect(game.score).to be_zero
    end

    it 'frames should have the next_frame set' do
      frames = game.frames

      9.times do |i|
        expect(expect(frames[i].next_frame).to eq frames[i + 1] )
      end
      expect(frames[9].next_frame).to be nil
    end
  end
end
