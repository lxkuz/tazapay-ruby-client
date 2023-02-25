# frozen_string_literal: true

# Implementation of the MTN API remittances client

require "tazapay/config"
require "tazapay/client"

module Tazapay
  # Bank API
  class Bank < Client
    def add(account_id:, bank_data:)
      path = "v1/bank"
      data = bank_data.merge(account_id: account_id)
      send_request(method: :post, path: path, body: data)
    end

    def list(account_id)
      path = "v1/bank/#{account_id}"
      send_request(method: :get, path: path)
    end

    def make_primary(account_id:, bank_id:)
      path = "v1/bank/primary"
      send_request(method: :put, path: path, body: {
                     account_id: account_id,
                     bank_id: bank_id
                   })
    end
  end
end
