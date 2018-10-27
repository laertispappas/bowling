module Result
  class Success
    attr_reader :success, :data

    def initialize(data = nil)
      @success = true
      @data = data
    end

    def on_success(&block)
      block.call(data)
      self
    end

    def on_failure(&block)
      self
    end

    def and_then(&block)
      result = block.call(data)

      result.tap do |res|
        unless res.is_a?(Result::Success) || res.is_a?(Result::Error)
          raise ArgumentError.new, 'Unexpected return object'
        end
      end
    end
  end

  class Error
    attr_reader :success, :error_msg, :data

    def initialize(error_msg, data = nil)
      @success = false

      if error_msg.is_a?(StandardError)
        ex = error_msg
        @error_msg = ex.message
        @data = ex
      else
        @error_msg = error_msg
        @data = data
      end
    end

    def on_success(&block)
      self
    end

    def on_failure(&block)
      block.call(error_msg, data)
      self
    end

    def and_then(&block)
      self
    end
  end
end
