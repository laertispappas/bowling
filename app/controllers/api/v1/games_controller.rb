module Api
  module V1
    class GamesController < ApplicationController
      def show
        game = Game.find(params[:id])
        render json: GameSerializer.new(game).as_json
      end

      def create
        game = GameFactory.create!(create_params)
        if game
          render json: GameSerializer.new(game).as_json, status: 201
        else
          render json: { message: 'cannot create game' }, status: 422
        end
      end

      private

      def create_params
        params.require(:users)
      end
    end
  end
end
