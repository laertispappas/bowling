module Api
  module V1
    class GamesController < ApplicationController
      def create
        game = GameFactory.create!(create_params)
        render json: game, status: 201
      end

      private

      def create_params
        params.require(:users)
      end
    end
  end
end
