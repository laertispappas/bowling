require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :name }

  describe '#score' do
    it 'returns the same of frames score' do
      frames = [double(score: 3), double(score: 2), double(score: 4)]
      allow(subject).to receive(:frames).and_return(frames)

      expect(subject.score).to eq 9
    end
  end

  describe '#roll' do
    it 'delegates to active frame' do
      pins = 1
      active_frame = NormalFrame.new
      allow(subject).to receive(:active_frame).and_return(active_frame)

      result = Result::Success.new
      expect(active_frame).to receive(:roll).with(pins).and_return(result)

      expect(subject.roll(pins)).to be_a Result::Success
    end
  end

  describe '#active_frame' do
    it 'returns the first active frame found' do
      first_active = double(active?: true)
      frames = [double(active?: false), first_active, double(active?: true)]
      allow(subject).to receive(:frames).and_return(frames)

      expect(subject.active_frame).to eq first_active
    end
  end

  describe '#completed_frames' do
    it 'returns the total number of completed frames' do
      non_completed = [double(active?: true), double(active?: true), double(active?: true)]
      completed = [double(active?: false), double(active?: false)]
      all_frames = completed + non_completed

      allow(subject).to receive(:frames).and_return(all_frames)
      expect(subject.completed_frames).to eq 2
    end
  end

  describe 'game_completed??' do
    it 'returns false when at least one frame is active' do
      frames = [double(active?: true), double(active?: false)]
      allow(subject).to receive(:frames).and_return(frames)
      expect(subject).to_not be_game_completed
    end

    it 'returns true when no frame is active' do
      frames = [double(active?: false), double(active?: false)]
      allow(subject).to receive(:frames).and_return(frames)
      expect(subject).to be_game_completed
    end
  end
end
