# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Tazapay::User do
  before do
    Tazapay.configure do |config|
      config.base_url = "https://api-sandbox.tazapay.com"
      config.access_key = "VL0DS5DYISNDW2U7O2NH"
      config.secret_key = "sandbox_pZ2J672Y8UN3e1qX1iNjpsb2jwhL8Fohi6X" \
                          "zfAcItHtu5Bf7HlAZE4LpyIegfKYoBGPuproyG7pMFV5MFHm0sdlBhrRtIQSmN04g" \
                          "HRuRP2d9VnqU7cJKg7r2LCH79OV4"
    end
  end

  let(:user) { described_class.new }

  describe "#create" do
    subject(:create_user) { user.create(user_data) }

    context "when individual",
            vcr: "user/create_individual" do
      let(:user_data) do
        {
          email: "sometest+11@mail.io",
          country: "US",
          ind_bus_type: "Individual",
          first_name: "Ansu",
          last_name: "K",
          contact_code: "+1",
          contact_number: "8888888888",
          partners_customer_id: "test-123"
        }
      end

      let(:create_user_response) do
        {
          "data" => {
            "account_id" => "2ec075b2-6efa-4aa0-858c-ae50585d5473",
            "country" => "US",
            "customer_id" => "test-123"
          },
          "message" => "User created successfully",
          "status" => "success"
        }
      end

      it "returns user data" do
        expect(create_user).to eq(create_user_response)
      end
    end

    context "when business", vcr: "user/create_business" do
      let(:user_data) do
        {
          email: "sometest+12@mail.io",
          country: "SG",
          ind_bus_type: "Business",
          business_name: "TEST SANDBOX",
          contact_code: "+65",
          contact_number: "9999999999",
          partners_customer_id: "test-123"
        }
      end

      let(:create_user_response) do
        {
          "status" => "success",
          "message" => "User created successfully",
          "data" => {
            "account_id" => "2526293f-6533-4ae0-b1f4-cc4b8ab95014",
            "customer_id" => "test-123",
            "country" => "SG"
          }
        }
      end

      it "returns user data" do
        expect(create_user).to eq(create_user_response)
      end
    end
  end

  describe "#find" do
    subject(:find_user) { user.find(id_or_email) }

    let(:response_data) do
      {
        "data" => { "company_name" => "TEST SANDBOX",
                    "contact_code" => "+65",
                    "contact_number" => "9999999999",
                    "country" => "Singapore",
                    "country_code" => "SG",
                    "customer_id" => "test-123",
                    "email" => "sometest+12@mail.io",
                    "first_name" => "",
                    "id" => "2526293f-6533-4ae0-b1f4-cc4b8ab95014",
                    "ind_bus_type" => "Business",
                    "last_name" => "" },
        "status" => "success"
      }
    end

    context "when user exists", vcr: "user/find_by_email_success" do
      let(:id_or_email) { "sometest+12@mail.io" }

      it "returns user data" do
        expect(find_user).to eq(response_data)
      end
    end

    context "when user exists", vcr: "user/find_by_id_success" do
      let(:id_or_email) { "2526293f-6533-4ae0-b1f4-cc4b8ab95014" }

      it "returns user data" do
        expect(find_user).to eq(response_data)
      end
    end

    context "when user doesn't exist", vcr: "user/find_not_found" do
      let(:id_or_email) { "nonexistentuser@example.com" }

      let(:error) do
        "Error code 404 {\"status\"=>\"error\", \"message\"=>\"resource not found\", " \
          "\"errors\"=>[{\"code\"=>1316, \"message\"=>\"user doesn't exist\"}]}"
      end

      it "returns error message" do
        expect { find_user }.to raise_error(error)
      end
    end
  end
end
