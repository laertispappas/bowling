class FrameSerializer < BaseSerializer
  def as_json(_opts = {})
    {
      score: object.score,
      rolls: object.rolls.map { |roll| RollSerializer.new(roll) }
    }
  end
end
