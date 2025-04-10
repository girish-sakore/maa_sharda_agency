require 'rails_helper'

RSpec.describe "Reports::AttendanceController", type: :request do
  include JwtHelper

  let(:admin) { FactoryBot.create(:admin) }
  let(:caller) { FactoryBot.create(:caller) }
  let(:executive) { FactoryBot.create(:executive) }
  let(:admin_token) { encode_token({ user_id: admin.id }) }
  let(:admin_headers) { { 'Authorization' => admin_token } }

  before do
    FactoryBot.create(:attendance, user: caller, date: Date.today, status: "late")
    FactoryBot.create(:attendance, user: executive, date: Date.today, status: "present")
    FactoryBot.create(:attendance, user: caller, date: Date.today - 1, status: "absent")
    FactoryBot.create(:attendance, user: caller, date: Date.today.beginning_of_month + 1, status: "present")
  end

  describe "GET /reports/attendance/daily" do
    it "returns daily report with summary and details" do
      get "/reports/attendance/daily", headers: admin_headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["summary"]).to include("late", "present")
      expect(json["details"].length).to be >= 2
    end
  end

  describe "GET /reports/attendance/monthly" do
    it "returns monthly report for a specific user" do
      get "/reports/attendance/monthly", params: {
        user_id: caller.id,
        date: Date.today
      }, headers: admin_headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["user_id"]).to eq(caller.id)
      expect(json["summary"]).to have_key("late").or have_key("absent").or have_key("present")
    end
  end

  describe "Unauthorized access" do
    it "blocks non-admins from daily report" do
      token = encode_token({ user_id: caller.id })
      get "/reports/attendance/daily", headers: { 'Authorization' => token }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
