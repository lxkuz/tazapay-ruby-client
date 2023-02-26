# frozen_string_literal: true

require "tazapay/config"
require "tazapay/client"

module Tazapay
  # KYB API
  class KYB < Client
    def create(data)
      path = "/v2/kyb/"
      send_request(method: :post, path: path, body: data)
    end

    def update(id:, data:)
      path = "/v2/kyb/#{id}"
      send_request(method: :put, path: path, body: data)
    end

    def status(account_id)
      path = "/v1/kyb/status/#{account_id}"
      send_request(method: :get, path: path)
    end

    def find(account_id)
      path = "/v2/kyb/#{account_id}"
      send_request(method: :get, path: path)
    end
  end
end
