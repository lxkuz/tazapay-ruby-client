# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Tazapay::Escrow do
  before do
    Tazapay.configure do |config|
      config.base_url = "https://api-sandbox.tazapay.com"
      config.access_key = "VL0DS5DYISNDW2U7O2NH"
      config.secret_key = "sandbox_pZ2J672Y8UN3e1qX1iNjpsb2jwhL8Fohi6X" \
                          "zfAcItHtu5Bf7HlAZE4LpyIegfKYoBGPuproyG7pMFV5MFHm0sdlBhrRtIQSmN04g" \
                          "HRuRP2d9VnqU7cJKg7r2LCH79OV4"
    end
  end

  let(:escrow) { described_class.new }

  describe "#create" do
    subject(:create) { escrow.create(data) }

    let(:data) do
      {
        txn_type: "goods",
        release_mechanism: "tazapay",
        reference_id: "test12345",
        initiated_by: seller_id,
        buyer_id: buyer_id,
        seller_id: seller_id,
        txn_description: "Positive transaction",
        txn_docs: [
          {
            type: "Proforma Invoice",
            url: "https://www.invoicesimple.com/wp-content/uploads/2018/06/Invoice-Template-top.xlsx"
          },
          {
            type: "Others",
            name: "Order Form",
            url: "https://www.invoicesimple.com/wp-content/uploads/2018/06/Invoice-Template-top.xlsx"
          }
        ],
        attributes: {},
        invoice_currency: "USD",
        invoice_amount: 1000,
        fee_tier: "standard",
        fee_paid_by: "buyer",
        fee_percentage: 100,
        release_docs: [
          {
            type: "Bill of Lading/ Airway Bill"
          },
          {
            type: "Others",
            name: "Packing List"
          }
        ],
        flat_fee: {
          amount: 10,
          label: "TEST-LABEL",
          paid_by: "buyer",
          payer_percentage: 100
        },
        # milestone_scheme: "Tpay Scheme 1",
        callback_url: "https://eoszvyoakmoeh2g.m.pipedream.net"
      }
    end

    context "when all params are valid", vcr: "escrow/create" do
      let(:seller_id) { "2526293f-6533-4ae0-b1f4-cc4b8ab95014" }
      let(:buyer_id) { "2ec075b2-6efa-4aa0-858c-ae50585d5473" }

      let(:create_response) do
        {
          "data" => { "collect_amount" => 1010,
                      "disburse_amount" => 1000,
                      "fee_amount" => 0,
                      "fee_paid_by" => "buyer",
                      "fee_tier" => "standard",
                      "fee_tier_percentage" => 0,
                      "flat_fee" => { "amount" => 10,
                                      "label" => "TEST-LABEL",
                                      "paid_by" => "buyer",
                                      "payer_percentage" => 100 },
                      "invoice_amount" => 1000,
                      "invoice_currency" => "USD",
                      "state" => "Awaiting_Payment",
                      "sub_state" => "Generic",
                      "transcation_source" => "api",
                      "txn_no" => "2302-782452",
                      "txn_type" => "goods" },
          "message" => "escrow created successfully",
          "status" => "success"
        }
      end

      it "responds with success" do
        expect(create).to eql(create_response)
      end
    end

    context "when some params are missing", vcr: "escrow/create_missing_params" do
      let(:initiated_by) { nil }
      let(:seller_id) { nil }
      let(:buyer_id) { nil }

      it "responds with error" do
        expect { create }.to raise_error(Tazapay::Error)
      end
    end
  end

  describe "#summary" do
    subject(:summary) { escrow.summary(txn_no) }

    context "when transaction exists", vcr: "escrow/summary" do
      let(:txn_no) { "2302-782452" }

      let(:summary_response) do
        {
          "data" => {
            "attributes" => {},
            "buyer" => { "company_name" => "",
                         "contact_name" => "Ansu K",
                         "country" => "US",
                         "country_alpha2" => "",
                         "email" => "a.kuznetsov+11@okft.io",
                         "ind_bus_type" => "Individual" },
            "buyer_id" => "2ec075b2-6efa-4aa0-858c-ae50585d5473",
            "collect_amount" => 1010,
            "disburse_amount" => 1000,
            "fee_amount" => 0,
            "fee_paid_by" => "buyer",
            "fee_tier_percentage" => 0,
            "initiated_by" => "2526293f-6533-4ae0-b1f4-cc4b8ab95014",
            "initiator_role" => "seller",
            "invoice_amount" => 1000,
            "invoice_currency" => "USD",
            "reference_id" => "test12345",
            "release_docs" => [{ "name" => "Packing List",
                                 "type" => "Others",
                                 "url" => "" },
                               { "name" => nil,
                                 "type" => "Bill of Lading/ Airway Bill",
                                 "url" => "" }],
            "release_mechanism" => "tazapay",
            "seller" => { "company_name" => "TEST SANDBOX",
                          "contact_name" => " ",
                          "country" => "SG",
                          "country_alpha2" => "",
                          "email" => "sometest+12@mail.io",
                          "ind_bus_type" => "Business" },
            "seller_id" => "2526293f-6533-4ae0-b1f4-cc4b8ab95014",
            "state" => "Awaiting_Payment",
            "sub_state" => "Generic",
            "txn_description" => "Positive transaction",
            "txn_docs" => [{ "name" => "Order Form",
                             "type" => "Others",
                             "url" => "1677353668897183587_Invoice-Template-top.xlsx_Order Form" },
                           { "name" => nil,
                             "type" => "Proforma Invoice",
                             "url" => "1677353668897176642_Invoice-Template-top.xlsx" }],
            "txn_no" => "2302-782452",
            "txn_type" => "goods"
          },
          "status" => "success"
        }
      end

      it "returns the transaction summary" do
        expect(summary).to eql(summary_response)
      end
    end

    context "when transaction does not exist", vcr: "escrow/summary_not_found" do
      let(:txn_no) { "invalid-transaction-id" }

      it "raises a Tazapay::Error" do
        expect { summary }.to raise_error(Tazapay::Error)
      end
    end
  end

  describe "#status" do
    subject(:status) { escrow.status(txn_no) }

    context "when transaction exists", vcr: "escrow/status" do
      let(:txn_no) { "2302-782452" }
      let(:status_response) do
        {
          "data" => { "invoice_amount" => 1000,
                      "invoice_currency" => "USD",
                      "partner_reference_id" => "test12345",
                      "state" => "Awaiting_Payment",
                      "sub_state" => "Generic",
                      "txn_no" => "2302-782452" },
          "status" => "success"
        }
      end

      it "responds with success" do
        expect(status).to eql(status_response)
      end
    end

    context "when transaction does not exist", vcr: "escrow/status_not_found" do
      let(:txn_no) { "not-found" }

      it "responds with error" do
        expect { status }.to raise_error(Tazapay::Error)
      end
    end
  end

  describe "#create_payment" do
    subject(:create_payment) { escrow.create_payment(data) }

    let(:data) do
      {
        txn_no: "2302-782452",
        complete_url: "https://www.google.com/",
        error_url: "https://duckduckgo.com/",
        callback_url: "https://eo23xhguawd2u8mbkd.m.pipedream.net",
        payment_methods: ["Card"]
      }
    end

    context "when all params are valid", vcr: "escrow/create_payment" do
      let(:create_payment_response) do
        {
          "data" => {
            "redirect_url" => "https://pay-sandbox.tazapay.com/marketplace/paymentdetails/" \
                              "76Ns_paTOUNMFswMvXoXoGz0Xn-6lNp_VFX1gwBLJGn-Ch6Fi3vYAEW3wKY2d0pd"
          },
          "message" => "payment session created successfully",
          "status" => "success"
        }
      end

      it "responds with success" do
        expect(create_payment).to eql(create_payment_response)
      end
    end

    context "when some params are missing", vcr: "escrow/create_payment_missing_params" do
      let(:data) { {} }

      it "responds with error" do
        expect { create_payment }.to raise_error(Tazapay::Error)
      end
    end
  end
end
