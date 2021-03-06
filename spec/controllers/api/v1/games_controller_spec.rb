require 'rails_helper'

require_relative './shared/expected_game_response_spec'

module Api
  module V1
    describe GamesController, type: :request do
      describe 'GET /api/v1/games/:id' do
        let(:users) { [{ name: 'A' }, { name: 'B' }] }
        let(:game) { GameFactory.create(users) }

        context 'initial game' do
          before { get "/api/v1/games/#{game.id}" }

          include_examples "game response"

          context 'requesting the game with If-None-Match specified in the header' do
            let(:do_request) do
              get "/api/v1/games/#{game.id}", headers: { 'If-None-Match' => etag_value }
            end

            context 'with an ETag mismatch' do
              before { do_request }

              let(:etag_value) { 'expired' }

              it { expect(response.status).to eq 200 }
              it { expect(payload).to be_present }
            end

            context 'with a matched ETag specified' do
              before { do_request }

              let(:etag_value) { response.headers['ETag'] }

              it { expect(response.status).to eq 304 }
              it { expect(response.body).to be_empty }
            end

            context 'when the game is updated' do
              before do
                game.roll(2)
                do_request
              end

              let(:etag_value) { response.headers['ETag'] }

              it { expect(response.status).to eq 200 }
              it { expect(payload).to be_present }
            end
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

          include_examples "game response"
          it { expect(response.status).to eq 200 }
        end

        context 'a completed game' do
          let(:users) { [{ name: "me" }] }

          before do
            1.upto(20) { game.roll(2) }
            get "/api/v1/games/#{game.id}"
          end

          include_examples "game response"

          it { expect(response.status).to eq 200 }
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

          include_examples "game response"
          it { expect(response.status).to eq 201 }
        end

        context 'on invalid params' do
          let(:params) do
            {
              users: [
                {
                  name: ''
                }
              ]
            }
          end

          it 'responds with the correct http code and json payload' do
            expect(response.status).to eq 422
            expect(response.message).to be_present
          end
        end
      end
    end
  end
end
