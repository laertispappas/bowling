require 'rails_helper'

module Api
  module V1
    describe GamesController, type: :request do
      include SpecSupport::GameResponseAssertions

      describe 'GET /api/v1/games/:id' do
        let(:users) { [{ name: 'A' }, { name: 'B' }] }
        let(:game) { GameFactory.create!(users) }

        context 'initial game' do
          before { get "/api/v1/games/#{game.id}" }

          it 'responds with the correct http code and json payload' do
            assert_game_response
          end
        end

        context 'with user rolls' do
          before do
            game.roll(1)
            game.roll(2)

            game.roll(5)
            game.roll(5)

            game.roll(3)
            game.roll(3)

            get "/api/v1/games/#{game.id}"
          end

          it 'responds with the correct http code and json payload' do
            expect(response.status).to eq 200
            assert_game_response
          end
        end
      end

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
            assert_game_response
          end
        end

        context 'on invalid params' do
          it 'responds with the correct http code and json payload'
        end
      end
    end
  end
end
