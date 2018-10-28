require 'rails_helper'

describe LastFrame, type: :model do
  it { is_expected.to be_a Frame }

  let(:game) { GameFactory.create([{ name: 'Katia' }]) }
  subject { game.players[0].frames.last }

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

  describe '#score' do
    it 'returns zero when no rolls exist' do
      expect(subject.score).to be_zero
    end

    context 'player does not score a spare nor a strike' do
      before do
        subject.roll(7)
        subject.roll(1)
      end

      it 'should not allow to roll another round' do
        expect(subject.score).to eq 8
      end
    end

    context 'player scores a spare' do
      before do
        subject.roll(3)
        subject.roll(7)
      end


      it 'should allow one more roll' do
        subject.roll(5)
        expect(subject.score).to eq 15
      end
    end

    context 'player scores a strike' do
      before do
        subject.roll(10)
      end

      it 'should allow two more rolls' do
        subject.roll(5)
        subject.roll(5)

        expect(subject.score).to eq 20
      end
    end
  end
end
