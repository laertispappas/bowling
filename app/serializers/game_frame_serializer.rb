class GameFrameSerializer < BaseSerializer
  def as_json(_opts = {})
    {
      total_score: object.game.score(object.user),
      id: object.user.id,
      name: object.user.name,
      frames: object.frames.map { |f| FrameSerializer.new(f) }
    }
  end
end
