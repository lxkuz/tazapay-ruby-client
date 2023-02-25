# frozen_string_literal: true

require "tazapay/config"
require "tazapay/client"

module Tazapay
  # Refund API
  class Refund < Client
    def request(txn_no:, amount: nil, callback_url: nil, remarks: nil, documents: nil)
      path = "/v1/payment/refund/request"
      data = {
        txn_no: txn_no,
        amount: amount,
        remarks: remarks,
        callback_url: callback_url,
        documents: documents
      }
      send_request(method: :post, path: path, body: data)
    end

    def status(txn_no)
      path = "/v1/payment/refund/status?txn_no=#{txn_no}"
      send_request(method: :get, path: path)
    end
  end
end
