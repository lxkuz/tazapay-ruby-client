# frozen_string_literal: true

require "tazapay/config"
require "tazapay/client"

module Tazapay
  # Metadata API
  class Metadata < Client
    def country_config(country)
      path = "v1/metadata/countryconfig?country=#{country}"
      send_request(method: :get, path: path)
    end

    def invoice_currency(buyer_country:, seller_country:)
      path = "v1/metadata/invoicecurrency?buyer_country=#{buyer_country}&seller_country=#{seller_country}"
      send_request(method: :get, path: path)
    end

    def collection_methods(buyer_country:, seller_country:, invoice_currency:, amount:)
      path = "v1/metadata/collect?buyer_country=#{buyer_country}" \
             "&seller_country=#{seller_country}&invoice_currency=#{invoice_currency}" \
             "&amount=#{amount}"
      send_request(method: :get, path: path)
    end

    def disbursement_methods(buyer_country:, seller_country:, invoice_currency:, amount:)
      path = "v1/metadata/disburse?buyer_country=#{buyer_country}" \
             "&seller_country=#{seller_country}&invoice_currency=#{invoice_currency}" \
             "&amount=#{amount}"
      send_request(method: :get, path: path)
    end

    def doc_upload_url
      path = "/v1/metadata/doc/upload"
      send_request(method: :get, path: path)
    end

    def kyb_doc(country)
      path = "/v1/metadata/kyb/doc?country=#{country}"
      send_request(method: :get, path: path)
    end

    def milestone_scheme
      path = "v1/metadata/milestone/scheme"
      send_request(method: :get, path: path)
    end
  end
end
