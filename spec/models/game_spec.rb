require "rails_helper"

describe Game, type: :model do
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
    context "player scores 2 pins in all frames" do
      before { roll_all(times: 20, pins: 2) }

      it "returns the correct total score" do
        expect(subject.score).to eq 40
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

        expect(subject.score).to eq 28
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

        expect(subject.score).to eq 33
      end
    end

    context "player scores a perfect game" do
      before { roll_all(times: 12, pins: 10) }

      it "returns the correct total score" do
        expect(subject.score).to eq 300
      end
    end
  end
end
