# frozen_string_literal: true

require "tazapay/config"
require "tazapay/client"

module Tazapay
  # Release API
  class Release < Client
    def release(txn_no:, release_docs:, callback_url:)
      path = "/v1/session/release"
      data = {
        txn_no: txn_no,
        release_docs: release_docs,
        callback_url: callback_url
      }
      send_request(method: :post, path: path, body: data)
    end
  end
end
