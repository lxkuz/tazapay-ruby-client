# frozen_string_literal: true

# Error handling for unsuccessful responses from the Tazapay API

module Tazapay
  # Stanadrd API error
  class Error < StandardError
    def initialize(message, code)
      @code = code
      super("Error code #{code} #{message}")
    end
  end

  # Validation error
  class ValidationError < StandardError
    def initialize(msg = message)
      super(msg)
    end
  end
end
