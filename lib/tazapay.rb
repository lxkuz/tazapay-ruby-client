# frozen_string_literal: true

require "tazapay/config"
require "tazapay/version"
require "tazapay/checkout"
require "tazapay/user"

# Head module
module Tazapay
  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Config.new
  end

  def self.reset
    @config = Config.new
  end

  def self.configure
    yield(config)
  end
end
