module Api
  module V1
    class RollsController < ApplicationController

      def create
        authorizer = RollAuthorizer.new(game, params)
        unless authorizer.call
          return render json: { message: authorizer.message }, status: 400
        end

        game.roll(create_params).on_success { |game|
          render json: GameSerializer.new(game), status: 201
        }.on_failure { |msg, _data|
          render json: { message: msg }, status: 400
        }
      end

      private

      def game
        @game ||= Game.find params[:game_id]
      end

      def create_params
        params.require :pins
      end
    end
  end
end
