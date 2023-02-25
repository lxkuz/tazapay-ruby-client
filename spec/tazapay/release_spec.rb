# frozen_string_literal: true

require "spec_helper"
require "vcr"
require "pry"

RSpec.describe Tazapay::Release do
  before do
    Tazapay.configure do |config|
      config.base_url = "https://api-sandbox.tazapay.com"
      config.access_key = "VL0DS5DYISNDW2U7O2NH"
      config.secret_key = "sandbox_pZ2J672Y8UN3e1qX1iNjpsb2jwhL8Fohi6X" \
                          "zfAcItHtu5Bf7HlAZE4LpyIegfKYoBGPuproyG7pMFV5MFHm0sdlBhrRtIQSmN04g" \
                          "HRuRP2d9VnqU7cJKg7r2LCH79OV4"
    end
  end

  let(:release_instance) { described_class.new }
  let(:release_docs) do
    [
      {
        type: "Bill of Lading/ Airway Bill",
        url: "https://www.invoicesimple.com/wp-content/uploads/2018/06/Invoice-Template-top.xlsx",
        file_name: "abc.pdf"
      },
      {
        type: "Others",
        name: "Packing List",
        url: "https://www.invoicesimple.com/wp-content/uploads/2018/06/Invoice-Template-top.xlsx",
        file_name: "xyz.png"
      }
    ]
  end

  describe "#release_class" do
    subject(:release) { release_instance.release(txn_no: txn_no, callback_url: "http://example.com", release_docs: release_docs) }

    context "when release went successfully", vcr: { cassette_name: "release/release_success" } do
      let(:txn_no) { "2302-168661" }
      let(:response_data) do
        {
          "data" => { "reference_id" => "c4766e09-c7a9-4954-b2d7-4f3e3eae065f" },
          "message" => "release session created successfully",
          "status" => "success"
        }
      end

      it "returns a success message" do
        expect(release).to eq(response_data)
      end
    end

    context "when account ID is invalid", vcr: { cassette_name: "release/invalid_txn_no" } do
      let(:txn_no) { "invalid" }

      it "returns an error message" do
        expect { release }.to raise_error(Tazapay::Error)
      end
    end
  end
end
