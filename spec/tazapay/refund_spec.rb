# frozen_string_literal: true

require "spec_helper"
require "vcr"
require "pry"

RSpec.describe Tazapay::Refund do
  before do
    Tazapay.configure do |config|
      config.base_url = "https://api-sandbox.tazapay.com"
      config.access_key = "VL0DS5DYISNDW2U7O2NH"
      config.secret_key = "sandbox_pZ2J672Y8UN3e1qX1iNjpsb2jwhL8Fohi6X" \
                          "zfAcItHtu5Bf7HlAZE4LpyIegfKYoBGPuproyG7pMFV5MFHm0sdlBhrRtIQSmN04g" \
                          "HRuRP2d9VnqU7cJKg7r2LCH79OV4"
    end
  end

  let(:refund_instance) { described_class.new }

  describe "#request" do
    subject(:refund_request) do
      refund_instance.request(txn_no: txn_no)
    end

    context "when params are valid", vcr: { cassette_name: "refund/request_success" } do
      let(:txn_no) { "2302-168661" }
      let(:response_data) do
        {
          "data" => { "reference_id" => "a5d9f4e2-92e4-4c92-8ebc-849fc7650421" },
          "status" => "success"
        }
      end

      it "returns a success message" do
        expect(refund_request).to eq(response_data)
      end
    end

    context "when tx no is invalid", vcr: { cassette_name: "refund/request_invalid_txn_no" } do
      let(:txn_no) { "invalid" }

      it "returns an error message" do
        expect { refund_request }.to raise_error(Tazapay::Error)
      end
    end
  end

  describe "#status" do
    subject(:refund_status) do
      refund_instance.status(txn_no)
    end

    context "when params are valid", vcr: { cassette_name: "refund/status_success" } do
      let(:txn_no) { "2302-168661" }
      let(:response_data) do
        {
          "status" => "success",
          "data" => { "reason" => "reason why we refunded", "reference_id" => "a5d9f4e2-92e4-4c92-8ebc-849fc7650421",
                      "status" => "approved", "updated_at" => "2021-02-21:4:20" }
        }
      end

      it "returns a success message" do
        expect(refund_status).to eq(response_data)
      end
    end

    context "when tx no is invalid", vcr: { cassette_name: "refund/status_invalid_txn_no" } do
      let(:txn_no) { "invalid" }

      it "returns an error message" do
        skip "API returns the same response with empty data"
        expect { refund_status }.to raise_error(Tazapay::Error)
      end
    end
  end
end
