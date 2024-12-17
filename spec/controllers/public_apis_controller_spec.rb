require 'rails_helper'

RSpec.describe 'PublicApis', type: :request do
  describe 'GET /types' do
    it 'returns a successful response' do
      get '/types'
      expect(response).to have_http_status(:ok)
    end

    it 'returns the correct account types' do
      get '/types'
      json_response = JSON.parse(response.body)
      expect(json_response['account_types']).to match_array(['admin', 'caller', 'executive'])
    end
  end
end
