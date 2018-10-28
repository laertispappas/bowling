require 'rails_helper'

describe GameFactory, type: :model do
  subject { described_class }

  describe '.create!' do
    let(:users) { [{ name: 'None' }, { name: 'Some' }] }
    let(:game) { subject.create(users) }

    it 'creates a game with 2 players' do
      expect(game).to be_persisted
      expect(game.players.count).to eq 2
    end

    it 'game has an initial score of zero for the user' do
      expect(game.score(User.first)).to be_zero
      expect(game.score(User.last)).to be_zero
    end

    it 'creates 10 frames for each player' do
      expect(game.players[0].frames.count).to eq 10
      expect(game.players[1].frames.count).to eq 10
    end

    it 'all frames should have the next_frame set to the next one except the last frame' do
      frames = game.players[0].frames
      9.times do |i|
        expect(expect(frames[i].next_frame).to eq frames[i + 1] )
      end
      expect(frames[9].next_frame).to be nil
    end

    it 'last frame should be a LastFrame instance and first ones should be NormalFrame instances' do
      expect(game.players[0].frames[-1]).to be_a(LastFrame)
      expect(game.players[1].frames[-1]).to be_a(LastFrame)

      all_first_normal = game.players[0].frames[0..-2].all? { |f| f.is_a?(NormalFrame) }
      expect(all_first_normal).to be true

      all_first_normal = game.players[1].frames[0..-2].all? { |f| f.is_a?(NormalFrame) }
      expect(all_first_normal).to be true
    end
  end
end
