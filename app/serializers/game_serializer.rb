class GameSerializer < BaseSerializer
  def as_json(_opts = {})
    {
      id: object.id,
      current_player_index: 0,
      players: object.game_frames.map { |gf| GameFrameSerializer.new(gf) }
    }
  end
end
