require 'rails_helper'

RSpec.describe "Admin Attendance API", type: :request do
  include JwtHelper

  let(:admin) { FactoryBot.create(:admin) }
  let(:caller) { FactoryBot.create(:caller) }
  let(:token) { encode_token({ user_id: admin.id }) }
  let(:headers) { { 'Authorization' => token } }

  it "lists all attendances" do
    FactoryBot.create(:attendance, user: caller, date: Date.today, status: "present")
    get "/attendances", headers: headers
    expect(response).to have_http_status(:ok)
  end

  it "creates a new attendance record" do
    post "/attendances", params: {
      attendance: {
        user_id: caller.id,
        date: Date.today,
        status: "present"
      }
    }, headers: headers

    expect(response).to have_http_status(:created)
  end

  it "fetches a user's attendance history" do
    FactoryBot.create(:attendance, user: caller, date: Date.today, status: "late")
    get "/users/#{caller.id}/attendances", headers: headers
    expect(response).to have_http_status(:ok)
  end

  describe "Non-admin tries to access admin routes" do
    it "forbids attendance index" do
      token = encode_token({ user_id: caller.id })
      get "/attendances", headers: { 'Authorization' => token }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
