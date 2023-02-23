# frozen_string_literal: true

# Base implementation of the MTN API client

# Includes methods common to collections, disbursements and remittances

require "faraday"

require "tazapay/config"
require "tazapay/errors"

module Tazapay
  # Base API client
  class Client
    def send_request(method:, path:, headers: default_headers, body: {})
      conn = faraday_with_block(url: Tazapay.config.base_url)
      conn.headers = headers
      conn.basic_auth(Tazapay.config.access_key, Tazapay.config.secret_key)
      case method.to_s
      when "get" then response = conn.get(path)
      when "post" then response = conn.post(path, body.to_json)
      end
      interpret_response(response)
    end

    def interpret_response(resp)
      body = resp.body.empty? ? "" : JSON.parse(resp.body)
      response = {
        body: body,
        code: resp.status
      }
      handle_error(response[:body], response[:code]) unless resp.status >= 200 && resp.status < 300
      body
    end

    def handle_error(response_body, response_code)
      raise Tazapay::Error.new(response_body, response_code)
    end

    private

    def faraday_with_block(options)
      Faraday.new(options)
      block = Tazapay.config.faraday_block
      if block
        Faraday.new(options, &block)
      else
        Faraday.new(options)
      end
    end

    def default_headers
      {
        "Content-Type" => "application/json"
      }
    end
  end
end
