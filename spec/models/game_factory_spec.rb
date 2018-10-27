require 'rails_helper'

describe GameFactory, type: :model do
  subject { described_class }

  describe '.create!' do
    let(:users) { [{ name: 'None' }, { name: 'Some' }] }
    let(:game) { subject.create(users) }

    it 'creates a game with 2 game frames' do
      expect(game).to be_persisted
      expect(game.game_frames.count).to eq 2

      expect(game.game_frames[0].active).to be true
      expect(game.game_frames[1].active).to be false
    end

    it 'creates a user for each game frame' do
      expect(game.game_frames[0].user.name).to eq 'None'
      expect(game.game_frames[1].user.name).to eq 'Some'
    end

    it 'game has an initial score of zero for the user' do
      expect(game.score(User.first)).to be_zero
      expect(game.score(User.last)).to be_zero
    end

    it 'all frames in a game frame should be 10' do
      expect(game.game_frames[0].frames.count).to eq 10
      expect(game.game_frames[1].frames.count).to eq 10
    end

    it 'all frames should have the next_frame set to the next one except the last frame' do
      frames = game.game_frames[0].frames
      9.times do |i|
        expect(expect(frames[i].next_frame).to eq frames[i + 1] )
      end
      expect(frames[9].next_frame).to be nil
    end

    it 'last frame should be a LastFrame instance and first ones should be NormalFrame instances' do
      expect(game.game_frames[0].frames[-1]).to be_a(LastFrame)
      expect(game.game_frames[1].frames[-1]).to be_a(LastFrame)

      all_first_normal = game.game_frames[0].frames[0..-2].all? { |f| f.is_a?(NormalFrame) }
      expect(all_first_normal).to be true

      all_first_normal = game.game_frames[1].frames[0..-2].all? { |f| f.is_a?(NormalFrame) }
      expect(all_first_normal).to be true
    end
  end
end
