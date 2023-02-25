# frozen_string_literal: true

# Implementation of the MTN API remittances client

require "tazapay/config"
require "tazapay/client"

module Tazapay
  # Users API
  class User < Client
    def create(data)
      path = "v1/user"
      send_request(method: :post, path: path, body: data)
    end

    def update(id, data)
      path = "v1/user"
      send_request(method: :post, path: path, body: data.merge(account_id: id))
    end

    def find(id_or_email)
      path = "v1/user/#{id_or_email}"
      send_request(method: :get, path: path)
    end
  end
end
