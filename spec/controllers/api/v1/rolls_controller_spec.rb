require 'rails_helper'

module Api
  module V1
    describe RollsController, type: :request do
      include SpecSupport::GameResponseAssertions

      before do
        post("/api/v1/games/#{game.id}/players/#{player.id}/frames/#{frame.id}/roll",
             params: params)
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
        let(:params) do
          {
            pins: 2
          }
        end

        it 'responds with the correct http status and payload' do
          expect(response.status).to eq 201
          assert_game_response
        end
      end

      context 'on invalid params' do
        pending
      end

      context 'on wrong user roll' do
        pending
      end

      context 'on wrong frame roll' do
        pending
      end
    end
  end
end
