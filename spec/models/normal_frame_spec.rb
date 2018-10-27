require 'rails_helper'

describe NormalFrame, type: :model do
  it { is_expected.to be_a Frame }

  let(:game) { GameFactory.create!([{ name: 'Ruby' }]) }

  subject { game.game_frames[0].frames.first }

  describe "#score" do
    context "current frame does not roll a spare nor a strike" do
      before do
        subject.roll(1)
        subject.roll(2)
      end

      context "next frame has not any rolls yet" do
        it "does not add any bonus to the score" do
          expect(subject.score).to eq 3
        end
      end

      context "next frame has some rolls" do
        before do
          subject.next_frame.roll(4)
          subject.next_frame.roll(3)
        end

        it "does not get any additional bonus" do
          expect(subject.score).to eq 3
        end
      end
    end

    context "current frame is a spare" do
      before do
        subject.roll(3)
        subject.roll(7)
      end

      context "next frame has not any rolls yet" do
        it "does not add any bonus to the score" do
          expect(subject.score).to eq 10
        end
      end

      context "next frame has some rolls" do
        before do
          subject.next_frame.roll(4)
          subject.next_frame.roll(3)
        end

        it "does gets the first roll score as additional bonus" do
          expect(subject.score).to eq 14
        end
      end
    end

    context "current frame is a strike" do
      before do
        subject.roll(10)
      end

      context "next frame has not any rolls yet" do
        it "does not add any bonus to the score" do
          expect(subject.score).to eq 10
        end
      end

      context "next frame has some rolls" do
        before do
          subject.next_frame.roll(4)
          subject.next_frame.roll(3)
        end

        it "does not get the next rolls score as bonus" do
          expect(subject.score).to eq 17
        end
      end

      context "next frame is a strike and not the last frame of the game" do
        before do
          subject.next_frame.roll(10)
        end

        it "returns the score with an additional bonus of 10" do
          expect(subject.score).to eq 20
        end

        context "on another roll" do
          before do
            subject.next_frame.next_frame.roll(5)
            subject.next_frame.next_frame.roll(3)
          end

          it "returns the score with an additional bonus form the next 2 rolls" do
            expect(subject.score).to eq 25
          end
        end
      end

      context "next frame is a strike and the last frame of the game" do
        before do
          subject.next_frame = game.game_frames[0].frames.last
          subject.save!
          subject.next_frame.roll(10)
        end

        it "returns the score with an additional bonus of 10" do
          expect(subject.score).to eq 20
        end

        context "on another roll" do
          before do
            subject.next_frame.roll(5)
            subject.next_frame.roll(3)
          end

          it "returns the score with an additional bonus form the next 2 rolls" do
            expect(subject.score).to eq 25
          end
        end
      end
    end
  end
end
