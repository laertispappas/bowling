module SpecSupport
  module RequestHelper
    def payload
      @payload ||= JSON.parse(response.body) if response.body.present?
    end
  end
end
