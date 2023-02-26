# frozen_string_literal: true

require "spec_helper"
require "pry"

RSpec.describe Tazapay::KYB do
  before do
    Tazapay.configure do |config|
      config.base_url = "https://api-sandbox.tazapay.com"
      config.access_key = "VL0DS5DYISNDW2U7O2NH"
      config.secret_key = "sandbox_pZ2J672Y8UN3e1qX1iNjpsb2jwhL8Fohi6X" \
                          "zfAcItHtu5Bf7HlAZE4LpyIegfKYoBGPuproyG7pMFV5MFHm0sdlBhrRtIQSmN04g" \
                          "HRuRP2d9VnqU7cJKg7r2LCH79OV4"
    end
  end

  let(:kyb) { described_class.new }
  let(:account_id) { "2526293f-6533-4ae0-b1f4-cc4b8ab95014" }

  describe "#create" do
    subject(:create_kyb) { kyb.create(kyb_data) }

    context "when data is valid", vcr: "kyb/create_success" do
      let(:kyb_data) do
        {
          account_id: "ee4cc3b2-3eb2-4bbd-b423-6eff717c7438",
          application_type: "Business",
          entity_name: "Company",
          submit: true,
          business: {
            name: "india mart api integration",
            type: "",
            incorporation_no: "GST-2344566",
            "address_line_1" => "Block.1, abc",
            "address_line_2" => "XYZ area",
            city: "Chennai",
            state: "TamilNadu",
            country: "India",
            zip_code: "600069",
            trading_name: "",
            category: [],
            sub_category: "",
            years_in_business: "",
            annual_turnover: "",
            website: "",
            date_of_incorporation: "",
            custom_attrs: {
              transaction_id: "1234"
            },
            documents: [
              {
                description: "Business Registration Proof",
                file_name: "busRegProof.png",
                name: "Business Registration Proof",
                proof_type: "Business",
                type: "Other",
                url: "https://i.pinimg.com/736x/53/af/1a/53af1ad615ee4f38e482d77b84eacb44.jpg"
              },
              {
                description: "Business Address Proof",
                file_name: "busAddressProof.png",
                name: "Business Address Proof",
                proof_type: "Address",
                tag: "addressProofDoc",
                type: "Other",
                url: "https://i.pinimg.com/736x/53/af/1a/53af1ad615ee4f38e482d77b84eacb44.jpg"
              }
            ]
          },
          representative: {
            first_name: "Steve",
            last_name: "Rogers",
            roles: ["Director"],
            dob: "",
            "address_line_1" => "add 1",
            "address_line_2" => "add 2",
            city: "Chennai",
            state: "TamilNadu",
            country: "India",
            zip_code: "600069",
            contact_code: "+91",
            mobile_number: "9090929220",
            nationality: "",
            ownership_percent: 50,
            documents: [
              {
                proof_type: "Identity",
                type: "Passport",
                name: "Address proof",
                url: "https://i.pinimg.com/736x/53/af/1a/53af1ad615ee4f38e482d77b84eacb44.jpg",
                file_name: "passportback.jpg",
                description: "representative passport",
                tag: "identityProofTypeFrontDoc"
              },
              {
                proof_type: "Identity",
                type: "Passport",
                name: "Address proof",
                url: "https://i.pinimg.com/736x/53/af/1a/53af1ad615ee4f38e482d77b84eacb44.jpg",
                file_name: "passportback.jpg",
                description: "representative passport",
                tag: "identityProofTypeBackDoc"
              }
            ]
          },
          owner: [
            {
              first_name: "Tony",
              last_name: "Stark",
              roles: ["Shareholder"],
              dob: "",
              "address_line_1" => "add 1",
              "address_line_2" => "add 2",
              city: "Chennai",
              state: "TamilNadu",
              country: "India",
              zip_code: "600069",
              contact_code: "+91",
              mobile_number: "9090929250",
              nationality: "",
              ownership_percent: 25,
              documents: [
                {
                  proof_type: "Identity",
                  type: "Passport",
                  name: "Address proof",
                  url: "https://i.pinimg.com/736x/53/af/1a/53af1ad615ee4f38e482d77b84eacb44.jpg",
                  file_name: "passportfront.jpg",
                  description: "representative passport",
                  tag: "identityProofTypeFrontDoc"
                },
                {
                  proof_type: "Identity",
                  type: "Passport",
                  name: "Address proof",
                  url: "https://i.pinimg.com/736x/53/af/1a/53af1ad615ee4f38e482d77b84eacb44.jpg",
                  file_name: "passportback.jpg",
                  description: "representative passport",
                  tag: "identityProofTypeBackDoc"
                }
              ]
            },
            {
              first_name: "Thor",
              last_name: "Odinson",
              roles: ["Shareholder"],
              dob: "",
              "address_line_1" => "add 1",
              "address_line_2" => "add 2",
              city: "Chennai",
              state: "TamilNadu",
              country: "India",
              zip_code: "600069",
              contact_code: "+91",
              mobile_number: "9090929229",
              nationality: "",
              ownership_percent: 25,
              documents: [
                {
                  proof_type: "Identity",
                  type: "Passport",
                  name: "Address proof",
                  url: "https://i.pinimg.com/736x/53/af/1a/53af1ad615ee4f38e482d77b84eacb44.jpg",
                  file_name: "passportfront.jpg",
                  description: "representative passport"
                },
                {
                  proof_type: "Identity",
                  type: "Passport",
                  name: "Address proof",
                  url: "https://i.pinimg.com/736x/53/af/1a/53af1ad615ee4f38e482d77b84eacb44.jpg",
                  file_name: "passportback.jpg",
                  description: "representative passport",
                  tag: "identityProofTypeBackDoc"
                }
              ]
            }
          ]
        }
      end

      let(:create_kyb_response) do
        {
          "data" => { "application_id" => "a01d242d-8860-4b67-9632-0ff51a1bb3c7" },
          "message" => "kyb application created successfully",
          "status" => "success"
        }
      end

      it "returns kyb data" do
        expect(create_kyb).to eq(create_kyb_response)
      end
    end
  end

  describe "#status" do
    subject(:kyb_status) { kyb.status(account_id) }

    let(:response_data) do
      {
        "data" => { "kyb_status" => "initiated" },
        "status" => "success"
      }
    end

    context "when kyb exists", vcr: "kyb/status_success" do
      it "returns kyb data" do
        expect(kyb_status).to eq(response_data)
      end
    end

    context "when kyb doesn't exist", vcr: "kyb/status_not_found" do
      let(:account_id) { "2526293f-6533-4ae0-1234-cc4b8ab95014" }

      let(:error) do
        'Error code 404 {"status"=>"error", "message"=>"user not found"}'
      end

      it "returns error message" do
        expect { kyb_status }.to raise_error(error)
      end
    end
  end

  describe "#find" do
    subject(:kyb_status) { kyb.find(account_id) }

    let(:response_data) do
      {
        "status" => "success",
        "data" => {
          "account_id" => "78e2fde6-a3bb-410c-99b7-56773fea7da8",
          "application_state" => "not_started",
          "entity_name" => "Company",
          "application_type" => "Business",
          "business" => {
            "id" => "f891cc0e-cfba-41c4-9e82-fdc702fd2564",
            "name" => "api integration v2",
            "type" => nil,
            "same_operating_address" => false,
            "incorporation_no" => "GST-2344566",
            "address_line_1" => "Block.1, abc",
            "address_line_2" => "XYZ area",
            "city" => "Chennai",
            "state" => "TamilNadu",
            "country" => "India",
            "zip_code" => "600069",
            "entity_type" => "",
            "entity_name" => nil,
            "trading_name" => "",
            "category" => nil,
            "sub_category" => "",
            "years_in_business" => "",
            "annual_turnover" => "",
            "website" => "",
            "date_of_incorporation" => nil,
            "custom_attrs" => {
              "transaction_id" => "123"
            },
            "documents" => [
              {
                "id" => "438433c9-4ea9-40f9-a389-bea3bcf8f0f9",
                "proof_type" => "Business",
                "type" => "Other",
                "tag" => "",
                "url" => "https://kyb-service-sandbox.s3.ap-southeast-1.amazonaws.com/20c749d6-9341-4aa5-a363-80d17c15ee40/busRegProof.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA2WN5GPXZGDAL5QI4%2F20220412%2Fap-southeast-1%2Fs3%2Faws4_request&X-Amz-Date=20220412T105709Z&X-Amz-Expires=3600&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEJv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaDmFwLXNvdXRoZWFzdC0xIkcwRQIgMijR7GhzcAt0i7MqNemWxsTIHF5itgSDjrQV28LeqtsCIQDq3vorgnc1GaoirojCD0JmyIc%2F%2F5WU2q1u6aUncn8ooCqwAghEEAEaDDczNTM3MzA2NTcxNCIMqJOo%2FnvVmqN8PRF%2FKo0CYhr87f8NjP4hauvRDJdAicvTlUrHRXdUE%2FrKSPvSeGcwySt87PpBT7DsR9zZEjOlYyNwrrcZcIgaePfWYTlA4vY7Z1IV0uP%2F942EPp6w%2BPDh4%2FTWlMZcd2Ea2QTtSraa4OyusNY5fCfhMUUFSGjgZlosKDIVPSvkNBVFiRGFsuSTi9t7j8qZVKQ7pR1UcPB8Kpggl5sOXP8GatYMl3eCug10heN1ZWSM7DGquog7lsxaXgKoifb3iJCddA2pXeenrDN%2F%2F7MxbpGoI%2BxQOxzPVPMr%2BEAMR5wDd3HErDZCRe80R9Ks6wz36Q63z7LK2eTcakCXNclYbcfEpLXSt%2BHndZCsqxajO5d7qGR5zWcwhLbVkgY6mgFVofyEbG0egB8tflNPl1CKJRaExxzLR3zSZFiNRKfx1lTL64LK2j%2FxLn3%2BDguk3ncu3Gl5vd9hFgRagDern9t0yEvQul0x4jSHLqAmb39cNKKzvZvZGek4DAt%2FF4rYUqQ4qIuQs64tcWpoYF91LsniEqK9J9z53oh1EL7HgkbbvFbVnqbul19v7ypU1gdE2hFyRB0R%2FQq21HUP&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3D%22%22&X-Amz-Signature=1f13ebd761919eb14eeada032c05568c2f41f7a02db21a44bf6b7fa61552f62f",
                "file_name" => "busRegProof.png",
                "name" => "Business Registration Proof",
                "description" => "Business Registration Proof"
              },
              {
                "id" => "8166009f-c1d4-4a49-b37f-991dfaf97ab1",
                "proof_type" => "Address",
                "type" => "Other",
                "tag" => "addressProofDoc",
                "url" => "https://kyb-service-sandbox.s3.ap-southeast-1.amazonaws.com/20c749d6-9341-4aa5-a363-80d17c15ee40/busAddressProof.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA2WN5GPXZGDAL5QI4%2F20220412%2Fap-southeast-1%2Fs3%2Faws4_request&X-Amz-Date=20220412T105709Z&X-Amz-Expires=3600&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEJv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaDmFwLXNvdXRoZWFzdC0xIkcwRQIgMijR7GhzcAt0i7MqNemWxsTIHF5itgSDjrQV28LeqtsCIQDq3vorgnc1GaoirojCD0JmyIc%2F%2F5WU2q1u6aUncn8ooCqwAghEEAEaDDczNTM3MzA2NTcxNCIMqJOo%2FnvVmqN8PRF%2FKo0CYhr87f8NjP4hauvRDJdAicvTlUrHRXdUE%2FrKSPvSeGcwySt87PpBT7DsR9zZEjOlYyNwrrcZcIgaePfWYTlA4vY7Z1IV0uP%2F942EPp6w%2BPDh4%2FTWlMZcd2Ea2QTtSraa4OyusNY5fCfhMUUFSGjgZlosKDIVPSvkNBVFiRGFsuSTi9t7j8qZVKQ7pR1UcPB8Kpggl5sOXP8GatYMl3eCug10heN1ZWSM7DGquog7lsxaXgKoifb3iJCddA2pXeenrDN%2F%2F7MxbpGoI%2BxQOxzPVPMr%2BEAMR5wDd3HErDZCRe80R9Ks6wz36Q63z7LK2eTcakCXNclYbcfEpLXSt%2BHndZCsqxajO5d7qGR5zWcwhLbVkgY6mgFVofyEbG0egB8tflNPl1CKJRaExxzLR3zSZFiNRKfx1lTL64LK2j%2FxLn3%2BDguk3ncu3Gl5vd9hFgRagDern9t0yEvQul0x4jSHLqAmb39cNKKzvZvZGek4DAt%2FF4rYUqQ4qIuQs64tcWpoYF91LsniEqK9J9z53oh1EL7HgkbbvFbVnqbul19v7ypU1gdE2hFyRB0R%2FQq21HUP&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3D%22%22&X-Amz-Signature=d473c9ae9042bb7bf83b3e823af3f5f3d9b14e770dea26766077f62dd69b2b72",
                "file_name" => "busAddressProof.png",
                "name" => "Business Address Proof",
                "description" => "Business Address Proof"
              }
            ],
            "description" => ""
          },
          "representative" => {
            "id" => "ad44d3b3-b3a2-407f-9f98-d277b7e7142a",
            "first_name" => "Steve",
            "last_name" => "Rogers",
            "same_operating_address" => false,
            "dob" => "",
            "address_line_1" => "add 1",
            "address_line_2" => "add 2",
            "city" => "Chennai",
            "state" => "TamilNadu",
            "country" => "India",
            "zip_code" => "600069",
            "mobile_number" => "9090929229",
            "nationality" => "",
            "ownership_percent" => 50,
            "ownership_status" => false,
            "type" => "Representative",
            "roles" => [],
            "documents" => [
              {
                "id" => "bcdae991-83be-4f75-a09b-e61df815eba2",
                "proof_type" => "Identity",
                "type" => "Passport",
                "tag" => "identityProofTypeFrontDoc",
                "url" => "https://kyb-service-sandbox.s3.ap-southeast-1.amazonaws.com/20c749d6-9341-4aa5-a363-80d17c15ee40/passportback.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA2WN5GPXZGDAL5QI4%2F20220412%2Fap-southeast-1%2Fs3%2Faws4_request&X-Amz-Date=20220412T105709Z&X-Amz-Expires=3600&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEJv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaDmFwLXNvdXRoZWFzdC0xIkcwRQIgMijR7GhzcAt0i7MqNemWxsTIHF5itgSDjrQV28LeqtsCIQDq3vorgnc1GaoirojCD0JmyIc%2F%2F5WU2q1u6aUncn8ooCqwAghEEAEaDDczNTM3MzA2NTcxNCIMqJOo%2FnvVmqN8PRF%2FKo0CYhr87f8NjP4hauvRDJdAicvTlUrHRXdUE%2FrKSPvSeGcwySt87PpBT7DsR9zZEjOlYyNwrrcZcIgaePfWYTlA4vY7Z1IV0uP%2F942EPp6w%2BPDh4%2FTWlMZcd2Ea2QTtSraa4OyusNY5fCfhMUUFSGjgZlosKDIVPSvkNBVFiRGFsuSTi9t7j8qZVKQ7pR1UcPB8Kpggl5sOXP8GatYMl3eCug10heN1ZWSM7DGquog7lsxaXgKoifb3iJCddA2pXeenrDN%2F%2F7MxbpGoI%2BxQOxzPVPMr%2BEAMR5wDd3HErDZCRe80R9Ks6wz36Q63z7LK2eTcakCXNclYbcfEpLXSt%2BHndZCsqxajO5d7qGR5zWcwhLbVkgY6mgFVofyEbG0egB8tflNPl1CKJRaExxzLR3zSZFiNRKfx1lTL64LK2j%2FxLn3%2BDguk3ncu3Gl5vd9hFgRagDern9t0yEvQul0x4jSHLqAmb39cNKKzvZvZGek4DAt%2FF4rYUqQ4qIuQs64tcWpoYF91LsniEqK9J9z53oh1EL7HgkbbvFbVnqbul19v7ypU1gdE2hFyRB0R%2FQq21HUP&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3D%22%22&X-Amz-Signature=2fe4ddcb3fecd6a995d21d08a80bd99362724966248ce86b17cebe3da3d3c45d",
                "file_name" => "passportback.jpg",
                "name" => "Address proof",
                "description" => "representative passport"
              },
              {
                "id" => "f6c3d79b-ef49-4eca-a634-a5f9e4c70edc",
                "proof_type" => "Identity",
                "type" => "Passport",
                "tag" => "identityProofTypeBackDoc",
                "url" => "https://kyb-service-sandbox.s3.ap-southeast-1.amazonaws.com/20c749d6-9341-4aa5-a363-80d17c15ee40/passportback.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=ASIA2WN5GPXZGDAL5QI4%2F20220412%2Fap-southeast-1%2Fs3%2Faws4_request&X-Amz-Date=20220412T105709Z&X-Amz-Expires=3600&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEJv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaDmFwLXNvdXRoZWFzdC0xIkcwRQIgMijR7GhzcAt0i7MqNemWxsTIHF5itgSDjrQV28LeqtsCIQDq3vorgnc1GaoirojCD0JmyIc%2F%2F5WU2q1u6aUncn8ooCqwAghEEAEaDDczNTM3MzA2NTcxNCIMqJOo%2FnvVmqN8PRF%2FKo0CYhr87f8NjP4hauvRDJdAicvTlUrHRXdUE%2FrKSPvSeGcwySt87PpBT7DsR9zZEjOlYyNwrrcZcIgaePfWYTlA4vY7Z1IV0uP%2F942EPp6w%2BPDh4%2FTWlMZcd2Ea2QTtSraa4OyusNY5fCfhMUUFSGjgZlosKDIVPSvkNBVFiRGFsuSTi9t7j8qZVKQ7pR1UcPB8Kpggl5sOXP8GatYMl3eCug10heN1ZWSM7DGquog7lsxaXgKoifb3iJCddA2pXeenrDN%2F%2F7MxbpGoI%2BxQOxzPVPMr%2BEAMR5wDd3HErDZCRe80R9Ks6wz36Q63z7LK2eTcakCXNclYbcfEpLXSt%2BHndZCsqxajO5d7qGR5zWcwhLbVkgY6mgFVofyEbG0egB8tflNPl1CKJRaExxzLR3zSZFiNRKfx1lTL64LK2j%2FxLn3%2BDguk3ncu3Gl5vd9hFgRagDern9t0yEvQul0x4jSHLqAmb39cNKKzvZvZGek4DAt%2FF4rYUqQ4qIuQs64tcWpoYF91LsniEqK9J9z53oh1EL7HgkbbvFbVnqbul19v7ypU1gdE2hFyRB0R%2FQq21HUP&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3D%22%22&X-Amz-Signature=2fe4ddcb3fecd6a995d21d08a80bd99362724966248ce86b17cebe3da3d3c45d",
                "file_name" => "passportback.jpg",
                "name" => "Address proof",
                "description" => "representative passport"
              }
            ],
            "email" => "",
            "contact_code" => "+91",
            "website" => ""
          }
        }
      }
    end

    context "when kyb exists", vcr: "kyb/find_success" do
      it "returns kyb data" do
        expect(kyb_status).to eq(response_data)
      end
    end

    context "when kyb doesn't exist", vcr: "kyb/find_not_found" do
      let(:account_id) { "2526293f-6533-4ae0-1234-cc4b8ab95014" }

      let(:error) do
        'Error code 404 {"status"=>"error", "message"=>"resource not found", ' \
          '"errors"=>[{"remarks"=>"id", "code"=>1005}]}'
      end

      it "returns error message" do
        expect { kyb_status }.to raise_error(error)
      end
    end
  end

  describe "#update" do
    subject(:update_kyb) { kyb.update(id: account_id, data: update_data) }

    context "when successful",
            vcr: "kyb/update_success" do
      let(:update_data) do
        {
          submit: true
        }
      end

      let(:update_kyb_response) do
        {
          "data" => { "application_id" => "a01d242d-8860-4b67-9632-0ff51a1bb3c7" },
          "message" => "kyb application updated successfully",
          "status" => "success"
        }
      end

      it "returns kyb data" do
        expect(update_kyb).to eq(update_kyb_response)
      end
    end
  end
end
