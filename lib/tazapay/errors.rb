# frozen_string_literal: true

# Error handling for unsuccessful responses from the Tazapay API

module Tazapay
  # Stanadrd API error
  class Error < StandardError
    attr_reader :code, :response_body

    def initialize(message, code)
      @code = code
      @response_body = message
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
