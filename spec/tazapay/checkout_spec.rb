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

  describe "#pay" do
    subject(:pay) { client.pay(data) }

    context "when all params are valid", vcr: "checkout/pay" do
      let(:data) do
        {
          buyer: {
            email: "a.kuznetsov+3@okft.io",
            contact_code: "+1",
            contact_number: "1111111111",
            country: "US",
            ind_bus_type: "Business",
            business_name: "Test12341"
          },
          seller: {
            email: "a.kuznetsov+2@okft.io",
            contact_code: "+65",
            contact_number: "1111111111",
            country: "SG",
            ind_bus_type: "Business",
            business_name: "Test12341"
          },
          fee_paid_by: "buyer",
          fee_percentage: 100,
          invoice_currency: "USD",
          invoice_amount: 1000,
          txn_description: "test0101",
          callback_url: "https://eoszvawdmoeh2g.m.pipedream.net",
          complete_url: "https://gooawdecom",
          error_url: "https://gooawdgle.com",
          payment_methods: ["Card"],
          txn_docs: [
            {
              type: "Proforma Invoice",
              url: "https://image.shutterstock.com/image-vector/luxurious-nature-floral-leaf-ornament-600w-1938357313.jpg",
              name: "Screenshot from 2022-01-17 20-41-22.png"
            }
          ],
          attributes: {
            doc_url: "https://media.istockphoto.com/photos/historic-buildings-of-wall-street-in-the-financial-district-of-lower-picture-id1337246025?s=612x612"
          }
        }
      end

      let(:pay_response) do
        { "data" => { "attributes" => {
                        "doc_url" => "https://media.istockphoto.com/photos/historic-buildings-of-wall-street-in-the-financial-district-of-lower-picture-id1337246025?s=612x612"
                      },
                      "buyer" => { "country" => "US",
                                   "email" => "a.kuznetsov+3@okft.io",
                                   "id" => "d9fe1daf-9f5a-4471-9424-b23c941aacc6" },
                      "collect_amount" => 1000,
                      "disburse_amount" => 1000,
                      "fee_amount" => 0,
                      "fee_paid_by" => "buyer",
                      "fee_tier" => "standard",
                      "fee_tier_percentage" => 0,
                      "invoice_amount" => 1000,
                      "invoice_currency" => "USD",
                      "partner_reference_id" => "",
                      "redirect_url" => "https://pay-sandbox.tazapay.com/marketplace/paymentdetails/_nqVw4c5x6TOoJqvubBacQuQ5wBgoEvnp_iAeE89IMSSn849bIjWGOvRs0ttLtAF",
                      "seller" => { "country" => "US",
                                    "email" => "a.kuznetsov+2@okft.io",
                                    "id" => "4337aff8-bab9-437f-8a54-83adcc8b5b5b" },
                      "state" => "Awaiting_Payment",
                      "sub_state" => "Generic",
                      "token" => "_nqVw4c5x6TOoJqvubBacQuQ5wBgoEvnp_iAeE89IMSSn849bIjWGOvRs0ttLtAF",
                      "transcation_source" => "api",
                      "txn_no" => "2302-781666",
                      "txn_type" => "goods" },
          "message" => "Payment Link created successfully",
          "status" => "success" }
      end

      it "responds with success" do
        expect(pay).to eql(pay_response)
      end
    end

    context "when some params are missing", vcr: "checkout/pay_missing_params" do
      let(:data) do
        {
          fee_paid_by: "buyer",
          fee_percentage: 100,
          invoice_currency: "USD",
          txn_description: "test0101",
          callback_url: "https://eoszvawdmoeh2g.m.pipedream.net",
          complete_url: "https://gooawdecom",
          error_url: "https://gooawdgle.com",
          payment_methods: ["Card"],
          txn_docs: [
            {
              type: "Proforma Invoice",
              url: "https://image.shutterstock.com/image-vector/luxurious-nature-floral-leaf-ornament-600w-1938357313.jpg",
              name: "Screenshot from 2022-01-17 20-41-22.png"
            }
          ],
          attributes: {
            doc_url: "https://media.istockphoto.com/photos/historic-buildings-of-wall-street-in-the-financial-district-of-lower-picture-id1337246025?s=612x612"
          }
        }
      end

      let(:error_message) do
        "{\"status\"=>\"error\", \"message\"=>\"Bad Request : Your request is invalid\", " \
          "\"errors\"=>[{\"code\"=>2901, \"message\"=>\"buyer_id/seller_id field is required and " \
          "must be a valid UUID\", \"remarks\"=>\"buyer_id\"}, {\"code\"=>2910, \"message\"=>\"Field " \
          "is required and value must be greater than 0\", \"remarks\"=>\"invoice_amount\"}]}"
      end

      it "responds with error" do
        expect { pay }.to raise_error("Error code 400 #{error_message}")
      end
    end
  end
end
