# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Tazapay::Checkout do
  before do
    Tazapay.configure do |config|
      config.base_url = "https://api-sandbox.tazapay.com"
      config.access_key = "VL0DS5DYISNDW2U7O2NH"
      config.secret_key = "sandbox_pZ2J672Y8UN3e1qX1iNjpsb2jwhL8Fohi6X" \
                          "zfAcItHtu5Bf7HlAZE4LpyIegfKYoBGPuproyG7pMFV5MFHm0sdlBhrRtIQSmN04g" \
                          "HRuRP2d9VnqU7cJKg7r2LCH79OV4"
    end
  end

  let(:client) { described_class.new }

  describe "#get_status" do
    subject(:tx_status) { client.get_status(tx_number) }

    context "when transaction is valid",
            vcr: "checkout/get_status" do
      let(:tx_number) { "2302-168661" }

      let(:tx_data) do
        {
          "data" => {
            "attributes" => {
              "doc_url" => "https://media.istockphoto.com/photos/historic-buildings-of-wall-street-in-the-financial-district-of-lower-picture-id1337246025?s=612x612"
            },
            "buyer" => { "company_name" => "Test12341",
                         "contact_name" => " ",
                         "country" => "US",
                         "country_alpha2" => "",
                         "email" => "a.kuznetsov+3@okft.io",
                         "ind_bus_type" => "Business" },
            "fee_paid_by" => "buyer",
            "invoice_amount" => 1000,
            "invoice_currency" => "USD",
            "reference_id" => "",
            "seller" => { "company_name" => "",
                          "contact_name" => "Ansu K",
                          "country" => "US",
                          "country_alpha2" => "",
                          "email" => "a.kuznetsov+2@okft.io",
                          "ind_bus_type" => "Individual" },
            "state" => "Awaiting_Payment",
            "sub_state" => "Generic",
            "txn_description" => "test0101",
            "txn_no" => tx_number,
            "txn_type" => "goods"
          },
          "status" => "success"
        }
      end

      it "returns transaction data" do
        expect(tx_status).to eq(tx_data)
      end
    end

    context "when the transaction number is invalid",
            vcr: "checkout/get_status_invalid_number" do
      let(:tx_number) { "9999-168661" }

      let(:error_message) do
        "{\"status\"=>\"error\", \"message\"=>\"Bad Request : " \
          "Your request is invalid\", \"errors\"=>[{\"code\"=>1005, " \
          "\"message\"=>\"The resource you are trying to retrieve is not present. " \
          "This error code happens when trying to Get or Read a data point (eg: transaction number, " \
          "user, KYB, etc) that does not exist.\"}]}"
      end

      it "returns an error response" do
        expect { tx_status }.to raise_error("Error code 400 #{error_message}")
      end
    end
  end
end
