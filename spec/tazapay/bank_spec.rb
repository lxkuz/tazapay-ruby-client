# frozen_string_literal: true

require "spec_helper"
require "vcr"
require "pry"

RSpec.describe Tazapay::Bank do
  before do
    Tazapay.configure do |config|
      config.base_url = "https://api-sandbox.tazapay.com"
      config.access_key = "VL0DS5DYISNDW2U7O2NH"
      config.secret_key = "sandbox_pZ2J672Y8UN3e1qX1iNjpsb2jwhL8Fohi6X" \
                          "zfAcItHtu5Bf7HlAZE4LpyIegfKYoBGPuproyG7pMFV5MFHm0sdlBhrRtIQSmN04g" \
                          "HRuRP2d9VnqU7cJKg7r2LCH79OV4"
    end
  end

  let(:bank) { described_class.new }
  let(:account_id) { "2526293f-6533-4ae0-b1f4-cc4b8ab95014" }

  describe "#add" do
    subject(:add_bank) { bank.add(account_id: account_id, bank_data: bank_data) }

    let(:bank_data) do
      {
        currency: "USD",
        bank_name: "Adkinson Securities Ltd",
        legal_name: "Adkinson Securities Ltd",
        account_number: "985214758563",
        is_primary_account: true,
        bank_codes: {
          "SWIFT Code" => "ADKSTHB1"
        }
      }
    end

    context "when bank is added successfully", vcr: { cassette_name: "bank/add_success" } do
      let(:response_data) do
        {
          "status" => "success",
          "data" => {
            "bank_id" => "3d8786ba-1083-4cfc-a40c-604f3669a208"
          }
        }
      end

      it "returns a success message" do
        expect(add_bank).to eq(response_data)
      end
    end

    context "when account ID is invalid", vcr: { cassette_name: "bank/add_invalid_account_id" } do
      let(:account_id) { "invalid" }

      it "returns an error message" do
        # Unfortunately API responds with 500 in such case
        expect { add_bank }.to raise_error(Tazapay::Error)
      end
    end
  end

  describe "#list" do
    subject(:list_banks) { bank.list(account_id) }

    context "when banks are listed successfully", vcr: { cassette_name: "bank/list_success" } do
      let(:response_data) do
        {
          "status" => "success",
          "data" => {
            "count" => 1,
            "banks" => [
              {
                "id" => "3d8786ba-1083-4cfc-a40c-604f3669a208",
                "bank_name" => "Adkinson Securities Ltd",
                "account_number" => "985214758563",
                "currency" => "USD",
                "country" => "Singapore",
                "legal_name" => "Adkinson Securities Ltd",
                "contact_code" => nil,
                "contact_number" => nil,
                "bank_codes" => {
                  "SWIFT Code" => "ADKSTHB1"
                },
                "is_primary_account" => true,
                "address" => "",
                "city" => "",
                "state" => "",
                "zip_code" => ""
              }
            ]
          }
        }
      end

      it "returns a list of banks" do
        expect(list_banks).to eq(response_data)
      end
    end
  end

  describe "#make_primary" do
    subject(:make_primary) { bank.make_primary(account_id: account_id, bank_id: bank_id) }

    let(:bank_id) { "3d8786ba-1083-4cfc-a40c-604f3669a208" }

    context "when bank is made primary successfully", vcr: { cassette_name: "bank/make_primary_success" } do
      let(:response_data) do
        {
          "status" => "success"
        }
      end

      it "returns a success message" do
        expect(make_primary).to eq(response_data)
      end
    end

    context "when account ID is invalid", vcr: { cassette_name: "bank/make_primary_invalid_account_id" } do
      let(:account_id) { "invalid" }

      it "raises a Tazapay::Error exception" do
        expect { make_primary }.to raise_error(Tazapay::Error)
      end
    end

    context "when bank ID is invalid", vcr: { cassette_name: "bank/make_primary_invalid_bank_id" } do
      let(:bank_id) { "invalid" }

      it "raises a Tazapay::Error exception" do
        expect { make_primary }.to raise_error(Tazapay::Error)
      end
    end
  end
end
