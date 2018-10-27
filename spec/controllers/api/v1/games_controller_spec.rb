require 'rails_helper'

module Api
  module V1
    describe GamesController, type: :request do
      # TODO: Spec support helper
      def payload
        @payload ||= JSON.parse(response.body)
      end

      # Not huge fun of loops in specs. But I will keep them for now
      #
      def assert_game_response
        game = Game.find(payload["id"])
        expect(payload["current_player"]).to eq game.current_player.id
        assert_players_response(game)
        assert_frames_response(game)
      end

      def assert_frames_response(game)
        game.game_frames.size.times do |gf_index|
          frames = payload["players"][gf_index]["frames"]
          expect(frames.size).to eq 10
          0.upto(9) do |f_index|
            persisted_frame = game.game_frames[gf_index].frames[f_index]
            expect(frames[f_index]["score"]).to eq(persisted_frame.score)
            expect(frames[f_index]["rolls"]).to eq(persisted_frame.rolls.map { |r| r.score })
          end
        end
      end

      def assert_players_response(game)
        players = payload["players"]
        expect(players.size).to eq game.game_frames.size
        players.size.times do |player_index|
          user = User.find(players[player_index]["id"])
          expect(players[player_index]["total_score"]).to eq game.score(user)
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
