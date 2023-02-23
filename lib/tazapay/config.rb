# frozen_string_literal: true

module Tazapay
  # Configuration storage
  class Config
    attr_accessor :base_url, :access_key, :secret_key, :faraday_block

    def initialize
      @environment = nil
      @base_url = nil
      @environment = nil
      @base_url = nil
      @access_key = nil
      @secret_key = nil
      @faraday_block = nil
    end
  end
end
