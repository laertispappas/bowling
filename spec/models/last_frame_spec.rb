require 'rails_helper'

describe LastFrame, type: :model do
  it { is_expected.to be_a Frame }

  subject { LastFrame.create!(game: Game.create!) }

  describe '#active?' do
    context 'user rolls no strike nor spare' do
      it 'returns true when no rolls exist' do
        expect(subject).to be_active
      end

      it 'returns true when 1 roll exists' do
        subject.roll(1)
        expect(subject).to be_active
      end

      it 'returns false when 2 rolls exists' do
        subject.roll(1)
        subject.roll(3)
        expect(subject).to_not be_active
      end
    end

    context 'on a spare roll' do
      before do
        subject.roll(1)
        subject.roll(9)
      end

      it 'returns true' do
        expect(subject).to be_active
      end

      it 'returns false when the last spare bonus is rolled' do
        subject.roll(4)
        expect(subject).to_not be_active
      end
    end

    context 'on a strike roll' do
      before do
        subject.roll(10)
      end

      it 'returns true' do
        expect(subject).to be_active
      end

      it 'returns true when one strike bonus is rolled' do
        subject.roll(10)
        expect(subject).to be_active
      end

      it 'returns false when the second strike bonus is rolled' do
        subject.roll(10)
        subject.roll(10)
        expect(subject).to_not be_active
      end
    end
  end
end
