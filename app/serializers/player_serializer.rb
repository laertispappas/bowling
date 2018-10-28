class PlayerSerializer < BaseSerializer
  def as_json(_opts = {})
    {
      total_score: object.game.score(object),
      id: object.id,
      name: object.name,
      frames: object.frames.map { |f| FrameSerializer.new(f) }
    }
  end
end
