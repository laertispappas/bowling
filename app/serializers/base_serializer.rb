class BaseSerializer
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def as_json(_opts = {})
    raise NotImplementedError
  end
end
