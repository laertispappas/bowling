class GameSerializer < BaseSerializer
  def as_json(_opts = {})
    {
      id: object.id,
      current_player: object.current_player&.id,
      current_frame: object.current_active_frame&.id,
      completed: object.completed?,
      winner: object.winner,
      players: players
    }
  end

  private

  def players
    object.game_frames.map { |gf| GameFrameSerializer.new(gf) }
  end
end
