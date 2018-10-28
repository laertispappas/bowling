require "rails_helper"

describe Game, type: :model do
  let(:user) { User.find_by_name!('John') }
  let(:users) { [{ name: 'John' }] }
  subject { GameFactory.create(users) }

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

  describe '#roll' do
    it 'returns a Result::Error when the user completes his game' do
      roll_all(times: 20, pins: 0)

      res = subject.roll(1)
      expect(res).to be_a Result::Error
    end

    it 'returns a Result::Success instance on a successful roll' do
      res = subject.roll(2)
      expect(res).to be_a Result::Success
      expect(res.data).to eq subject
    end

    context 'when no current active frames exist' do
      before do
        roll_all(times: 20, pins: 2)
      end

      it 'returns a Result::Error instance' do
        res = subject.roll(1)
        expect(res).to be_a Result::Error
      end
    end

    context 'when a current active frame exists with one user' do
      it 'rolls for the current user' do
        subject.roll(3)
        subject.roll(3)

        subject.roll(10)
        subject.roll(10)

        frames = subject.players[0].frames
        expect(frames[0].rolls.count).to eq 2
        expect(frames[1].rolls.count).to eq 1
        expect(frames[2].rolls.count).to eq 1
      end
    end

    context 'when a current active frame exists with multiple users' do
      let(:users) { [{ name: 'AP' }, { name: 'LP' }] }
      subject { GameFactory.create(users) }

      it 'rolls for the correct user turn' do
        subject.roll(3)
        subject.roll(3)
        expect(subject.players[0].frames[0].rolls.count).to eq 2
        expect(subject.players[1].frames[0].rolls.count).to eq 0

        subject.roll(3)
        subject.roll(3)
        expect(subject.players[0].frames[0].rolls.count).to eq 2
        expect(subject.players[1].frames[0].rolls.count).to eq 2
      end
    end

    context 'multiple users complete the game' do
      let(:users) { [{ name: 'AP' }, { name: 'LP' }] }
      subject { GameFactory.create(users) }

      it 'has the correct score for all of them' do
        roll_all(times: 40, pins: 2)

        user_1 = User.find_by_name!('AP')
        user_2 = User.find_by_name!('LP')

        expect(subject.score(user_1)).to eq 40
        expect(subject.score(user_2)).to eq 40
      end
    end
  end

  describe '#completed?' do
    let(:users) { [{name: "a"}] }

    it 'returns false when game is not completed' do
      game = Game.new
      game.players.new
      game.players.first.frames.new
      expect(game).to_not be_completed
    end

    it 'returns true when game is completed' do
      roll_all(times: 20, pins: 2)
      expect(subject).to be_completed
    end
  end

  describe '#winner' do
    let(:game) { Game.new }

    it 'returns nil for non completed game' do
      allow(game).to receive(:completed?).and_return(false)
      expect(game.winner).to eq nil
    end

    it 'returns the winner for a completed game' do
      user_1 = User.new(name: 'better next time')
      user_2 = User.new(name: 'winner')
      players = [user_1, user_2]

      allow(game).to receive(:completed?).and_return(true)
      allow(game).to receive(:players).and_return(players)
      allow(game).to receive(:score).with(user_1).and_return(120)
      allow(game).to receive(:score).with(user_2).and_return(222)

      expect(game.winner).to eq user_2.name
    end
  end

  describe '#current_player' do
    let(:users) { [{ name: 'John' }, { name: 'Mike' }] }

    subject { GameFactory.create(users) }

    it 'returns the current active player' do
      expect(subject.current_player).to eq subject.players[0]
    end

    it 'returns the correct current player' do
      subject.roll(1)
      expect(subject.current_player).to eq subject.players[0]
      subject.roll(2)
      expect(subject.current_player).to eq subject.players[1]

      subject.roll(10)
      expect(subject.current_player).to eq subject.players[0]

      subject.roll(10)
      expect(subject.current_player).to eq subject.players[1]
    end
  end
end
