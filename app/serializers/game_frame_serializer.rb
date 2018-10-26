class GameFrameSerializer < BaseSerializer
  def as_json(_opts = {})
    {
      total_score: 0,
      frames: object.frames.map { |f| FrameSerializer.new(f) }
    }
  end
end
