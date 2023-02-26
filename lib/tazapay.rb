# frozen_string_literal: true

require "tazapay/config"
require "tazapay/version"
require "tazapay/checkout"
require "tazapay/escrow"
require "tazapay/release"
require "tazapay/refund"
require "tazapay/user"
require "tazapay/bank"
require "tazapay/metadata"
require "tazapay/kyb"

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
