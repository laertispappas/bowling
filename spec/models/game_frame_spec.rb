require 'rails_helper'

RSpec.describe GameFrame, type: :model do
  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :game }

  describe 'completed?' do
    it 'returns false when at least one frame is active' do
      frames = [double(active?: true), double(active?: false)]
      allow(subject).to receive(:frames).and_return(frames)
      expect(subject).to_not be_completed
    end

    it 'returns true when at no frame is active' do
      frames = [double(active?: false), double(active?: false)]
      allow(subject).to receive(:frames).and_return(frames)
      expect(subject).to be_completed
    end
  end
end
