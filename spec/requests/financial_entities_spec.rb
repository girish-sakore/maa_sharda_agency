require 'rails_helper'

RSpec.describe "/financial_entities", type: :request do

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    it "renders a successful response" do
      FinancialEntity.create! valid_attributes
      get financial_entities_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      financial_entity = FinancialEntity.create! valid_attributes
      get financial_entity_url(financial_entity), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new FinancialEntity" do
        expect {
          post financial_entities_url,
               params: { financial_entity: valid_attributes }, headers: valid_headers, as: :json
        }.to change(FinancialEntity, :count).by(1)
      end

      it "renders a JSON response with the new financial_entity" do
        post financial_entities_url,
             params: { financial_entity: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new FinancialEntity" do
        expect {
          post financial_entities_url,
               params: { financial_entity: invalid_attributes }, as: :json
        }.to change(FinancialEntity, :count).by(0)
      end

      it "renders a JSON response with errors for the new financial_entity" do
        post financial_entities_url,
             params: { financial_entity: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested financial_entity" do
        financial_entity = FinancialEntity.create! valid_attributes
        patch financial_entity_url(financial_entity),
              params: { financial_entity: new_attributes }, headers: valid_headers, as: :json
        financial_entity.reload
        skip("Add assertions for updated state")
      end

      it "renders a JSON response with the financial_entity" do
        financial_entity = FinancialEntity.create! valid_attributes
        patch financial_entity_url(financial_entity),
              params: { financial_entity: new_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "renders a JSON response with errors for the financial_entity" do
        financial_entity = FinancialEntity.create! valid_attributes
        patch financial_entity_url(financial_entity),
              params: { financial_entity: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested financial_entity" do
      financial_entity = FinancialEntity.create! valid_attributes
      expect {
        delete financial_entity_url(financial_entity), headers: valid_headers, as: :json
      }.to change(FinancialEntity, :count).by(-1)
    end
  end
end
