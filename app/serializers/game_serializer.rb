class GameSerializer < BaseSerializer
  def as_json(_opts = {})
    {
      id: object.id,
      current_player: object.current_player.id,
      players: object.game_frames.map { |gf| GameFrameSerializer.new(gf) }
    }
  end
end
