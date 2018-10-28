class PlayerSerializer < BaseSerializer
  def as_json(_opts = {})
    {
      total_score: object.score,
      id: object.id,
      name: object.name,
      frames: object.frames.map { |f| FrameSerializer.new(f) }
    }
  end
end
