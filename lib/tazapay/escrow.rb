# frozen_string_literal: true

require "tazapay/config"
require "tazapay/client"

module Tazapay
  # Escrow API
  class Escrow < Client
    def create(data)
      path = "/v1/escrow"
      send_request(method: :post, path: path, body: data)
    end

    def summary(tx_no)
      path = "/v1/escrow/#{tx_no}/summary"
      send_request(method: :get, path: path)
    end

    def create_payment(data)
      path = "/v1/session/payment"
      send_request(method: :post, path: path, body: data)
    end

    def status(tx_no)
      path = "/v1/escrow/#{tx_no}"
      send_request(method: :get, path: path)
    end
  end
end
