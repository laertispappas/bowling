require 'rails_helper'

module Api
  module V1
    describe RollsController, type: :request do
      include SpecSupport::GameResponseAssertions

      let(:do_request) do
        post("/api/v1/games/#{game.id}/players/#{player.id}/frames/#{frame.id}/roll",
             params: params)
      end

      let(:params) do
        {
          pins: 9
        }
      end

      let(:game) { GameFactory.create!(players) }
      let(:player) { game.current_player }
      let(:frame) { player.frames.first }
      let(:players) do
        [
          {
            name: 'LP'
          },
          {
            name: 'AP'
          }
        ]
      end

      context 'on valid params' do
        before { do_request }

        it 'responds with the correct http status and payload' do
          expect(response.status).to eq 201
          assert_game_response
        end
      end

      context 'on invalid params' do
        let(:params) do
          {
            pins: -12
          }
        end

        it 'responds with the correct http status and payload' do
          do_request
          expect(response.status).to eq 400
          expect(payload["message"]).to be_present
        end
      end

      context 'on wrong user roll' do
        let(:player) { game.players.first }

        it 'responds with bad request and the correct error message' do
          game.roll(10)
          do_request

          expect(response.status).to eq 400
          expect(payload['message']).to be_present
        end
      end

      context 'on wrong frame roll' do
        let(:frame) { player.frames.last }

        it 'responds with bad request and the correct error message' do
          do_request

          expect(response.status).to eq 400
          expect(payload['message']).to be_present
        end
      end
    end
  end
end
