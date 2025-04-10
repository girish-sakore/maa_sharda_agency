require 'rails_helper'

RSpec.describe "Attendance API", type: :request do
  include JwtHelper

  let(:caller) { FactoryBot.create(:caller) }
  let(:admin) { FactoryBot.create(:admin) }
  let(:token) { encode_token({ user_id: caller.id }) }
  let(:headers) { { 'Authorization' => token } }
  let(:admin_headers) { { 'Authorization' => encode_token({ user_id: admin.id }) } }

  describe "POST /attendance/check_in" do
    it "checks in successfully for today" do
      post "/attendance/check_in", headers: headers
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["check_in_time"]).to be_present
    end

    it "prevents duplicate check-in" do
      post "/attendance/check_in", headers: headers
      post "/attendance/check_in", headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "prevents admin check-in" do
      post "/attendance/check_in", headers: admin_headers
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /attendance/check_out" do
    it "checks out successfully after check-in" do
      post "/attendance/check_in", headers: headers
      patch "/attendance/check_out", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["check_out_time"]).to be_present
    end

    it "checks out successfully after check-in" do
      post "/attendance/check_in", headers: headers
      patch "/attendance/check_out", headers: headers
      patch "/attendance/check_out", headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
    end

    it "fails to check out without check-in" do
      patch "/attendance/check_out", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
