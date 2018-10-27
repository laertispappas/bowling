require 'rails_helper'

module Api
  module V1
    describe GamesController, type: :request do
      # TODO: Spec support helper
      def payload
        @payload ||= JSON.parse(response.body)
      end

      def assert_game_response
        game = Game.find(payload["id"])
        expect(payload["current_player"]).to eq game.current_player.id

        players = payload["players"]
        expect(players[0]["id"]).to eq game.game_frames[0].user.id
        expect(players.size).to eq game.game_frames.size

        frames = players[0]["frames"]
        expect(frames.size).to eq 10
        0.upto(9) do |i|
          frame = game.game_frames[0].frames[i]
          expect(frames[i]["score"]).to eq(frame.score)
          expect(frames[i]["rolls"]).to eq(frame.rolls.map { |r| r.score })
        end

        frames = players[1]["frames"]
        expect(players[1]["id"]).to eq game.game_frames[1].user.id
        expect(frames.size).to eq 10
        0.upto(9) do |i|
          expect(frames[i]["score"]).to be_zero
          expect(frames[i]["rolls"]).to be_empty
        end
      end

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
