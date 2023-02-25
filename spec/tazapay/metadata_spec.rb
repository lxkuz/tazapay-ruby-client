# frozen_string_literal: true

require "spec_helper"
require "vcr"
require "pry"

RSpec.describe Tazapay::Metadata do
  before do
    Tazapay.configure do |config|
      config.base_url = "https://api-sandbox.tazapay.com"
      config.access_key = "VL0DS5DYISNDW2U7O2NH"
      config.secret_key = "sandbox_pZ2J672Y8UN3e1qX1iNjpsb2jwhL8Fohi6X" \
                          "zfAcItHtu5Bf7HlAZE4LpyIegfKYoBGPuproyG7pMFV5MFHm0sdlBhrRtIQSmN04g" \
                          "HRuRP2d9VnqU7cJKg7r2LCH79OV4"
    end
  end

  let(:metadata) { described_class.new }

  describe "#country_config" do
    subject(:country_config) { metadata.country_config(country) }

    let(:country) { "SG" }

    context "when country is valid", vcr: { cassette_name: "metadata/country_config" } do
      let(:response_data) do
        {
          "status" => "success",
          "data" => {
            "buyer_countries" => %w[AE AG AI AL AM AO
                                    AR AT AU AW AZ BA BB BD BE
                                    BF BG BH BI BJ BM BN BO BR
                                    BS BW BZ CA CH CI CL CM CN
                                    CO CR CV CW CY CZ DE DJ DK
                                    DM DO DZ EE EG ES ET FI FJ
                                    FK FO FR GA GB GD GE GH GI
                                    GL GM GQ GR GT GW GY HK HN
                                    HR HT HU ID IE IL IN IS IT
                                    JM JO JP KE KG KH KM KN KR
                                    KW KY KZ LA LB LC LI LK LR
                                    LS LT LU LV MA MC MD MG ML
                                    MM MN MO MR MS MT MU MV MW
                                    MX MY MZ NA NC NE NG NI NL
                                    NO NP NZ OM PA PE PF PG PH
                                    PK PL PR PT PY QA RO RS SA
                                    SB SC SE SG SH SI SK SL SN
                                    SR ST SX SZ TD TG TH TJ TM
                                    TO TR TT TW TZ UA UG US UY
                                    UZ VC VG VN VU WF WS ZA ZM],
            "market_type" => "both",
            "seller_countries" => %w[AE AG AI AL AM AO AR AT AU AW AZ BA
                                     BB BD BE BF BG BH BI BJ BM BN BO BR
                                     BS BW BZ CA CH CI CL CM CN CO CR CV
                                     CW CY CZ DE DJ DK DM DO DZ EE EG ES
                                     ET FI FJ FK FO FR GA GB GD GE GH GI
                                     GL GM GQ GR GT GW GY HK HN HR HT HU
                                     ID IE IL IN IS IT JM JO JP KE KG KH
                                     KM KN KR KW KY KZ LA LB LC LI LK LR
                                     LS LT LU LV MA MC MD MG ML MM MN MO
                                     MR MS MT MU MV MW MX MY MZ NA NC NE
                                     NG NI NL NO NP NZ OM PE PF PG PH
                                     PK PL PR PT PY QA RO RS SA SB SC
                                     SE SG SH SI SK SL SN SR ST SX SZ
                                     TD TG TH TJ TM TO TR TT TW TZ UA
                                     UG US UY UZ VC VG VN VU WF WS ZA ZM]
          }
        }
      end

      it do
        expect(country_config).to eq(response_data)
      end
    end

    context "when country is invalid", vcr: { cassette_name: "metadata/country_config_invalid" } do
      let(:country) { "INVALID" }

      it do
        expect { country_config }.to raise_error(Tazapay::Error)
      end
    end
  end

  describe "#invoice_currency" do
    subject(:invoice_currency) do
      metadata.invoice_currency(buyer_country: buyer_country, seller_country: seller_country)
    end

    let(:buyer_country) { "SG" }
    let(:seller_country) { "US" }

    context "when buyer and seller countries are valid", vcr: { cassette_name: "metadata/invoice_currency" } do
      let(:response_data) do
        {
          "status" => "success",
          "data" => {
            "currencies" => %w[USD SGD EUR GBP]
          }
        }
      end

      it "returns the expected currency" do
        expect(invoice_currency).to eq(response_data)
      end
    end

    context "when buyer country is invalid",
            vcr: { cassette_name: "metadata/invoice_currency_invalid_buyer_country" } do
      let(:buyer_country) { "INVALID" }

      it "raises a Tazapay::Error" do
        expect { invoice_currency }.to raise_error(Tazapay::Error)
      end
    end

    context "when seller country is invalid",
            vcr: { cassette_name: "metadata/invoice_currency_invalid_seller_country" } do
      let(:seller_country) { "INVALID" }

      it "raises a Tazapay::Error" do
        expect { invoice_currency }.to raise_error(Tazapay::Error)
      end
    end
  end

  describe "#disbursement_methods" do
    subject(:disbursement_methods) do
      metadata.disbursement_methods(
        buyer_country: "TH",
        seller_country: "US",
        invoice_currency: "USD",
        amount: 100
      )
    end

    context "when input is valid", vcr: { cassette_name: "metadata/disbursement_methods_valid" } do
      let(:expected_response) do
        {
          "status" => "success",
          "data" => {
            "amount" => 100, "buyer_country" => "TH",
            "invoice_currency" => "USD",
            "seller_country" => "US",
            "settlement_currencies" => [
              {
                "amount" => 100, "currency" => "USD", "fx_rate" => 1, "is_minimum" => false
              }
            ]
          }
        }
      end

      it "returns the expected response" do
        expect(disbursement_methods).to eq(expected_response)
      end
    end

    context "when input is invalid", vcr: { cassette_name: "metadata/disbursement_methods_invalid" } do
      let(:invalid_input) do
        {
          buyer_country: "INVALID",
          seller_country: "US",
          invoice_currency: "USD",
          amount: 100
        }
      end

      it "raises a Tazapay::Error" do
        expect { metadata.disbursement_methods(invalid_input) }.to raise_error(Tazapay::Error)
      end
    end
  end

  describe "#collection_methods" do
    subject(:collection_methods) do
      metadata.collection_methods(
        buyer_country: "TH",
        seller_country: "US",
        invoice_currency: "USD",
        amount: 100
      )
    end

    context "when input is valid", vcr: { cassette_name: "metadata/collection_methods_valid" } do
      let(:expected_response) do
        {
          "status" => "success",
          "data" => {
            "amount" => 100,
            "buyer_country" => "TH",
            "collection_currencies" => [
              { "amount" => 3493.33,
                "currency" => "THB",
                "fx_rate" => 34.93331,
                "is_minimum" => false },
              {
                "amount" => 3493.33,
                "currency" => "THB",
                "fx_rate" => 34.93331,
                "is_minimum" => false
              },
              { "amount" => 100,
                "currency" => "USD",
                "fx_rate" => 1,
                "is_minimum" => false },
              { "amount" => 100,
                "currency" => "USD",
                "fx_rate" => 1,
                "is_minimum" => false }
            ],
            "invoice_currency" => "USD",
            "payment_methods" => [
              { "amount" => 3537,
                "bank_account" => "",
                "banks" => nil,
                "currency" => "THB",
                "fixed_fee" => 0,
                "fx_rate" => 35.369976,
                "name" => "PromptPay QR",
                "rank" => 1,
                "surcharge_amount" => 0,
                "tag" => "Best FX Rate",
                "txn_fee" => 0,
                "url" => ["https://tazapay-payment-logos.s3.ap-southeast-1.amazonaws.com/v2/PromptPay.svg"],
                "variable_fee" => 0 },
              { "amount" => 3598.13,
                "bank_account" => "",
                "banks" => nil,
                "currency" => "THB",
                "fixed_fee" => 0,
                "fx_rate" => 35.981309,
                "name" => "Card",
                "rank" => 1,
                "surcharge_amount" => 0,
                "tag" => "Instant",
                "txn_fee" => 0,
                "url" => ["https://tazapay-payment-logos.s3.ap-southeast-1.amazonaws.com/v2/Mastercard.svg",
                          "https://tazapay-payment-logos.s3.ap-southeast-1.amazonaws.com/v2/Visa.svg"],
                "variable_fee" => 0 },
              { "amount" => 100,
                "bank_account" => "",
                "banks" => nil,
                "currency" => "USD",
                "fixed_fee" => 0,
                "fx_rate" => 1,
                "name" => "Card",
                "rank" => 2,
                "surcharge_amount" => 0,
                "tag" => "Instant",
                "txn_fee" => 0,
                "url" => ["https://tazapay-payment-logos.s3.ap-southeast-1.amazonaws.com/v2/Mastercard.svg",
                          "https://tazapay-payment-logos.s3.ap-southeast-1.amazonaws.com/v2/Visa.svg"],
                "variable_fee" => 0 },
              { "amount" => 100,
                "bank_account" => "",
                "banks" => nil,
                "currency" => "USD",
                "fixed_fee" => 0,
                "fx_rate" => 1,
                "name" => "Wire Transfer",
                "rank" => 1,
                "surcharge_amount" => 0,
                "tag" => "",
                "txn_fee" => 0,
                "url" => ["https://tazapay-payment-logos.s3.ap-southeast-1.amazonaws.com/v2/Swift.svg"],
                "variable_fee" => 0 }
            ],
            "seller_country" => "US"
          }
        }
      end

      it "returns the expected response" do
        expect(collection_methods).to eq(expected_response)
      end
    end

    context "when input is invalid", vcr: { cassette_name: "metadata/collection_methods_invalid" } do
      let(:invalid_input) do
        {
          buyer_country: "INVALID",
          seller_country: "US",
          invoice_currency: "USD",
          amount: 100
        }
      end

      it "raises a Tazapay::Error" do
        expect { metadata.collection_methods(invalid_input) }.to raise_error(Tazapay::Error)
      end
    end
  end

  describe "#kyb_doc" do
    subject(:kyb_doc) { metadata.kyb_doc(country) }

    let(:country) { "TH" }

    context "when country is valid", vcr: { cassette_name: "metadata/kyb_doc" } do
      let(:response_data) do
        {
          "status" => "success",
          "data" => {
            "kyb_proof_document" => [
              { "name" => "Driver's License", "type" => "identity" },
              { "name" => "National ID", "type" => "identity" },
              { "name" => "Passport", "type" => "identity" },
              { "name" => "Other", "type" => "identity" },
              { "name" => "Driver's License", "type" => "address" },
              { "name" => "National ID", "type" => "address" },
              { "name" => "Passport", "type" => "address" },
              { "name" => "Other", "type" => "address" }
            ]
          }
        }
      end

      it "returns the expected data" do
        expect(kyb_doc).to eq(response_data)
      end
    end

    context "when country is invalid", vcr: { cassette_name: "metadata/kyb_doc_invalid" } do
      let(:country) { "INVALID" }

      it "raises a Tazapay::Error" do
        expect { kyb_doc }.to raise_error(Tazapay::Error)
      end
    end
  end

  describe "#milestone_scheme" do
    subject(:milestone_scheme) { metadata.milestone_scheme }

    context "when request is successful", vcr: { cassette_name: "metadata/milestone_scheme" } do
      let(:response_data) do
        {
          "data" => { "schemes" => nil }, "status" => "success"
        }
      end

      it "returns the milestone scheme data" do
        expect(milestone_scheme).to eq(response_data)
      end
    end
  end

  describe "#doc_upload_url" do
    subject(:doc_upload_url) { metadata.doc_upload_url }

    context "when request is successful", vcr: { cassette_name: "metadata/doc_upload_url" } do
      let(:response_data) do
        {
          "data" => {
            "upload_url" => "SOMETESTURL"
          }, "status" => "success"
        }
      end

      it do
        expect(doc_upload_url).to eq(response_data)
      end
    end
  end
end
