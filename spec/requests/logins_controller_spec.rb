require 'rails_helper'

def jwt_decode(token)
  JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
end

def json_response
  JSON.parse(response.body)
end

describe 'POST /login', type: :request do
  let(:user) { FactoryBot.create(:user, :caller, email: 'test@example.com', password: 'password123') }

  context 'when the request is valid' do
    it 'returns a token and user details' do
      post '/login', params: { email: user.email, password: 'password123' }
      
      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(user.id)
      expect(json_response['type']).to eq(user.type)
      expect(json_response['token']).not_to be_nil
      decoded_payload = jwt_decode(json_response['token'])
      expect(decoded_payload['user_id']).to eq(user.id)
    end
  end

  context 'when the email is invalid' do
    it 'returns an unauthorized status and error message' do
      post '/login', params: { email: 'wrong@example.com', password: 'password123' }
      
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['error']).to eq('Invalid email or password')
    end
  end

  context 'when the password is invalid' do
    it 'returns an unauthorized status and error message' do
      post '/login', params: { email: user.email, password: 'wrongpassword' }
      
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['error']).to eq('Invalid email or password')
    end
  end

  context 'when the email and password are missing' do
    it 'returns an unauthorized status and error message' do
      post '/login', params: {}
      
      expect(response).to have_http_status(:unauthorized)
      expect(json_response['error']).to eq('Invalid email or password')
    end
  end
end
