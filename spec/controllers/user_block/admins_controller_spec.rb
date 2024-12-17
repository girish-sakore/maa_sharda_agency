# spec/requests/user_block/admins_controller_spec.rb
require 'rails_helper'
include JwtHelper

RSpec.describe UserBlock::AdminsController, type: :request do
  let!(:admin) { FactoryBot.create(:user, :admin) } # Create a sample admin for use in the specs
  let(:valid_attributes) {
    {
      "name"=>Faker::Name.name,
      "email"=> Faker::Internet.unique.email,
      "password"=>"password"
    }
  } # Define valid attributes for admin creation
  let(:invalid_attributes) { { name: nil, email: nil } } # Define invalid attributes
  let!(:token) { encode_token({ user_id: admin.id }) }
  let(:headers) { { 'Authorization' => token } }

  describe "GET /index" do
    it "returns a successful response" do
      get '/user_block/admins', headers: headers
      expect(response).to be_successful
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe "GET /show" do
    let(:admin2) { FactoryBot.create(:user, :admin)}
    it "returns a successful response" do
      get "/user_block/admins/#{admin2.id}", headers: headers
      expect(response).to be_successful
      expect(JSON.parse(response.body)["id"]).to eq(admin2.id)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Admin" do
        expect {
          post user_block_admins_path, params: { admin: valid_attributes }, headers: headers
        }.to change(UserBlock::Admin, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Admin" do
        expect {
          post user_block_admins_path, params: { admin: invalid_attributes }, headers: headers
        }.to change(UserBlock::Admin, :count).by(0)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { { name: "New Admin Name" } }

      it "updates the requested admin" do
        patch user_block_admin_path(admin), params: { admin: new_attributes }, headers: headers
        admin.reload
        expect(admin.name).to eq("New Admin Name")
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "does not update the requested admin" do
        patch user_block_admin_path(admin), params: { admin: invalid_attributes }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested admin" do
      expect {
        delete user_block_admin_path(admin), headers: headers
      }.to change(UserBlock::Admin, :count).by(-1)

      expect(response).to have_http_status(:ok)
    end
  end
end
