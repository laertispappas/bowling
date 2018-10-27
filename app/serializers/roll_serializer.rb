class RollSerializer < BaseSerializer
  def as_json(_opts = {})
    object.present? && object.pins
  end
end
