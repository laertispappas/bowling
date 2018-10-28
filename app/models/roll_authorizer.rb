class RollAuthorizer
  # Validates that the given input user is the current user's turn and
  # that the given input frame is the correct frame of the user to play.
  #
  # We do require a user and a frame to be passed in the API in order
  # to avoid and process a request multiple times. This will have the effect
  # and roll for the next availble current player if we allow it.
  #
  # For example:
  #
  # User 1 turn:
  #   game.roll(2)
  #   game.roll(3)
  #
  # Since game#roll has a reference to the current player internally repeated requests for some
  # reason (timeout ?) would roll for the next user if we had processed the initial one.
  #
  # Ideally we would change the #roll method to pass a user and a frame together with the pins
  # and make the validation inside the game class since if we had the requirement to call
  # game#roll outside the context of an API request, we would still have the same problem.
  #
  # Since Game#roll is only used int the API context I think it is better to keep the #roll
  # interface as is authorize the request in the controller level.
  #
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
