require 'rails_helper'

module Api
  module V1
    describe GamesController, type: :request do
      describe 'POST /api/v1/games' do
        before { post '/api/v1/games', params: params }

        context 'on valid params' do
          let(:params) do
            {
              users: [
                {
                  name: 'LP'
                },
                {
                  name: 'AP'
                }
              ]
            }
          end

          it 'responds with the correct http code and json payload' do
            expect(response.status).to eq 201
            payload = JSON.parse(response.body)
            expect(payload["id"]).to eq Game.last.id
            expect(payload["current_player_index"]).to eq 0

            players = payload["players"]
            expect(players.size).to eq 2

            frames = players[0]["frames"]
            expect(frames.size).to eq 10
            0.upto(9) do |i|
              expect(frames[i]["score"]).to be_zero
              expect(frames[i]["rolls"]).to be_empty
            end

            frames = players[1]["frames"]
            expect(frames.size).to eq 10
            0.upto(9) do |i|
              expect(frames[i]["score"]).to be_zero
              expect(frames[i]["rolls"]).to be_empty
            end
          end
        end

        context 'on invalid params' do
          it 'responds with the correct http code and json payload'
        end
      end
    end
  end
end
