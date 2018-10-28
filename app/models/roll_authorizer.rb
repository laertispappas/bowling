class RollAuthorizer
  attr_reader :game, :params, :message

  def initialize(game, params)
    @game = game
    @params = params
    @message = nil
  end

  def call
    @message = "Wrong user turn" unless correct_user_turn?
    @message = "Wrong frame slot" unless current_frame_slot?

    !@message
  end

  private

  def correct_user_turn?
    params[:player_id].to_i == game.current_player&.id
  end

  def current_frame_slot?
    params[:frame_id].to_i == game.current_active_frame&.id
  end
end
