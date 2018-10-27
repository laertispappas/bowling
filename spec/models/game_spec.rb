require "rails_helper"

describe Game, type: :model do
  let(:user) { User.find_by_name!('John') }
  let(:users) { [{ name: 'John' }] }
  subject { GameFactory.create!(users) }

  def roll_all(times:, pins:)
    0.upto(times - 1) { subject.roll(pins) }
  end

  def roll_strike
    subject.roll(10)
  end

  def roll_spare
    subject.roll(5)
    subject.roll(5)
  end

  describe "#score" do
    context "multiple players" do
      let(:john) { User.find_by_name!('John') }
      let(:mike) { User.find_by_name!('Mike') }
      let(:users) { [{ name: 'John' }, { name: 'Mike' }] }

      it 'returns the correct score for a given user' do
        # First user
        subject.roll(10)

        # 2nd user
        subject.roll(3)
        subject.roll(4)

        expect(subject.score(john)).to eq 10
        expect(subject.score(mike)).to eq 7
      end
    end

    context "player scores 2 pins in all frames" do
      before { roll_all(times: 20, pins: 2) }

      it "returns the correct total score for the given user" do
        expect(subject.score(user)).to eq 40
      end
    end

    context "player scores one spare" do
      it "returns the correct total score" do
        subject.roll(2)
        subject.roll(3)
        # 10 + 4 from the next roll
        roll_spare
        subject.roll(4)
        subject.roll(5)
        roll_all(times: 14, pins: 0)

        expect(subject.score(user)).to eq 28
      end
    end

    context "player scores one strike" do
      it "returns the correct total score" do
        subject.roll(2)
        subject.roll(3)
        # 10 + 4 + 5 from the next 2 rolls
        roll_strike
        subject.roll(4)
        subject.roll(5)
        roll_all(times: 14, pins: 0)

        expect(subject.score(user)).to eq 33
      end
    end

    context "player scores a perfect game" do
      before { roll_all(times: 12, pins: 10) }

      it "returns the correct total score" do
        expect(subject.score(user)).to eq 300
      end
    end
  end

  describe '#rolls' do
    it 'raises a game complete error when the user completes his game' do
      roll_all(times: 20, pins: 0)
      expect{ subject.roll(1) }.to raise_error(Game::GameCompleteError)
    end

    context 'when no current active frames exist' do
      subject { Game.new }
      before { expect(subject.game_frames).to be_empty }

      it 'should raise an error' do
        expect{ subject.roll(1) }.to raise_error(Game::GameCompleteError)
      end
    end

    context 'when a current active frame exists with one user' do
      it 'rolls for the current user' do
        subject.roll(3)
        subject.roll(3)

        subject.roll(10)
        subject.roll(10)

        frames = subject.game_frames[0].frames
        expect(frames[0].rolls.count).to eq 2
        expect(frames[1].rolls.count).to eq 1
        expect(frames[2].rolls.count).to eq 1
      end
    end

    context 'when a current active frame exists with multiple users' do
      let(:users) { [{ name: 'AP' }, { name: 'LP' }] }
      subject { GameFactory.create!(users) }

      it 'rolls for the correct user turn' do
        subject.roll(3)
        subject.roll(3)
        expect(subject.game_frames[0].frames[0].rolls.count).to eq 2
        expect(subject.game_frames[1].frames[0].rolls.count).to eq 0

        subject.roll(3)
        subject.roll(3)
        expect(subject.game_frames[0].frames[0].rolls.count).to eq 2
        expect(subject.game_frames[1].frames[0].rolls.count).to eq 2
      end
    end
  end

  describe '#create_game_frames!' do
    pending
  end

  describe '#current_player' do
    let(:users) { [{ name: 'John' }, { name: 'Mike' }] }

    subject { GameFactory.create!(users) }

    it 'returns the current active player' do
      expect(subject.current_player).to eq subject.game_frames[0].user
    end

    it 'returns the next player when the current user rolls 2 times' do
      subject.roll(1)
      expect(subject.current_player).to eq subject.game_frames[0].user
      subject.roll(2)
      expect(subject.current_player).to eq subject.game_frames[1].user
    end
  end
end
