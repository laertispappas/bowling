require 'rails_helper'

RSpec.describe Frame, type: :model do
  it { is_expected.to belong_to :game_frame }
  it { is_expected.to belong_to(:next_frame).class_name('Frame').with_foreign_key('next_frame_id') }
  it { is_expected.to have_many :rolls }

  let(:game) { Game.create! }
  let(:user) { User.create(name: 'Some') }
  let(:game_frame) { GameFrame.create!(game: game, user: user) }

  subject { Frame.create!(game_frame: game_frame, type: 'Frame') }

  describe "#roll" do
    it 'does not calls the on_frame_complete callback when frame is active' do
      called = false
      on_frame_complete = -> { called = true }
      subject.roll(1, on_frame_complete: on_frame_complete)

      expect(subject).to be_active
      expect(called).to be false
    end

    it 'calls the on_frame_complete callback when frame changes to inactive' do
      called = false
      on_frame_complete = -> { called = true }

      subject.roll(1, on_frame_complete: on_frame_complete)
      subject.roll(1, on_frame_complete: on_frame_complete)

      expect(subject).to_not be_active
      expect(called).to be true
    end

    context "frame is not active" do
      before { allow(subject).to receive(:active?).and_return(false) }

      it 'returns a Result::Error instance' do
        res = subject.roll(1)
        expect(res).to be_a Result::Error
        expect(res.error_msg).to be_present
      end
    end

    context "frame is active" do
      before { allow(subject).to receive(:active?).and_return(true) }

      it "creates store a new roll" do
        expect{ subject.roll(3) }.to change{ subject.rolls.count }.by(1)

        expect(subject.rolls.first.pins).to eq 3
      end

      it 'returns a Result::Success instance' do
        res = subject.roll(2)
        expect(res).to be_a Result::Success
      end
    end
  end


  describe "#score" do
    it "requires calcualte_bonus to be implemented" do
      expect { subject.score }.to raise_error(NotImplementedError)
    end

    it "returns the sum of the rolls plus any additional bonus" do
      allow(subject).to receive(:calculate_bonus).and_return(3)
      subject.roll(2)
      subject.roll(5)

      expect(subject.score).to eq 10
    end
  end

  describe "#active?" do
    it "returns true when no rolls exist" do
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
