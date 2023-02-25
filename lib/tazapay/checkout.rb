# frozen_string_literal: true

require "tazapay/config"
require "tazapay/client"

module Tazapay
  # Transactions API
  class Checkout < Client
    def pay(data)
      path = "/v1/checkout"
      send_request(method: :post, path: path, body: data)
    end

    def get_status(tx_number)
      path = "/v1/checkout/#{tx_number}"
      send_request(method: :get, path: path)
    end
  end
end
