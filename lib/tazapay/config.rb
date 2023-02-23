# frozen_string_literal: true

module Tazapay
  # Configuration storage
  class Config
    attr_accessor :environment, :base_url

    def initialize
      @environment = nil
      @base_url = nil
    end
  end
end
