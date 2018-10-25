require 'rails_helper'

RSpec.describe Frame, type: :model do
  it { is_expected.to belong_to :game }
  it { is_expected.to have_many :rolls }

  subject { Frame.create!(game: Game.create!) }

  describe "#roll" do
    context "frame is not active" do
      before { allow(subject).to receive(:active?).and_return(false) }

      it { expect{ subject.roll(1) }.to raise_error(Frame::RollError) }
    end
    context "frame is active" do
      before { allow(subject).to receive(:active?).and_return(true) }

      it "creates store a new roll" do
        expect{ subject.roll(3) }.to change{ subject.rolls.count }.by(1)

        expect(subject.rolls.first.pins).to eq 3
      end
    end
  end


  describe "#score" do
    it "returns the sum of the rolls" do
      subject.roll(2)
      subject.roll(5)

      expect(subject.score).to eq 7
    end
  end

  describe "#active?" do
    it "returns false when no rolls exist" do
      expect(subject.rolls).to be_empty
      expect(subject).to be_active
    end

    it "returns false when frame is scored with a strike" do
      subject.roll(10)
      expect(subject).to_not be_active
    end

    it "returns false when frame is scored with a spare" do
      subject.roll(5)
      subject.roll(5)
      expect(subject).to_not be_active
    end

    it "returns true when rolls are empty" do
      expect(subject.rolls).to be_empty
      expect(subject).to be_active
    end

    it "returns true when 1 roll is played for the frame" do
      subject.roll(2)
      expect(subject).to be_active
    end

    it "returns falls when 2 rolls are played for the frame" do
      subject.roll(2)
      subject.roll(3)
      expect(subject).to_not be_active
    end
  end
end
