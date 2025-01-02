require 'rails_helper'
include JwtHelper

RSpec.describe UserBlock::UsersController, type: :request do
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:caller) { FactoryBot.create(:user, :caller) }
  let!(:executive) { FactoryBot.create(:user, :executive) }
  let!(:users) { FactoryBot.create_list(:user, 3) }
  let(:user) { admin } # current user is admin
  let(:token) { encode_token({ user_id: user.id }) }
  let(:headers) { { 'Authorization' => token } }

  describe 'Unauthorized request' do
    it 'returns the error token not provided' do
      get "/user_block/users/#{caller.id}"
      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Token not provided')
    end

    it 'returns the error invalid token' do
      get "/user_block/users/#{caller.id}", headers: { 'Authorization' => 'invalid-token' }
      expect(response).to have_http_status(:unauthorized)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Invalid token')
    end
  end

  describe 'GET /users' do
    it 'returns a list of non-admin users' do
      get '/user_block/users', headers: headers
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['metadata']['total_users']).to eq(users.count + 2) # caller and executive
      expect(json_response['users'].all? { |user| user['type'] != 'UserBlock::Admin' }).to be true
    end
  end

  describe 'GET /users/:id' do
    it 'returns the details of a user' do
      get "/user_block/users/#{caller.id}", headers: headers
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(caller.id)
      expect(json_response['type']).to eq('UserBlock::Caller')
    end

    it 'returns 404 for a non-existent user' do
      get "/user_block/users/#{UserBlock::User.maximum(:id).to_i + 1}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /users' do
    let(:valid_attributes) { { type: 'caller', email: 'new_caller@example.com', name: 'New Caller', password: 'password' } }
    let(:invalid_attributes) { { type: 'UserBlock::Caller', email: '', name: '', password: '' } }

    context 'when the current user is an admin' do
      it 'creates a new caller user with valid attributes' do
        post '/user_block/users', params: valid_attributes, headers: headers
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['type']).to eq('UserBlock::Caller')
        expect(json_response['email']).to eq(valid_attributes[:email])
      end

      it 'creates a new executive user with valid attributes' do
        valid_attributes[:type] = 'executive'
        valid_attributes[:email] = 'new_executive@example.com'
        post '/user_block/users', params: valid_attributes, headers: headers
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['type']).to eq('UserBlock::Executive')
        expect(json_response['email']).to eq(valid_attributes[:email])
      end

      it 'creates a new admin user with valid attributes' do
        valid_attributes[:type] = 'admin'
        valid_attributes[:email] = 'admin@example.com'
        post '/user_block/users', params: valid_attributes, headers: headers
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['type']).to eq('UserBlock::Admin')
        expect(json_response['email']).to eq(valid_attributes[:email])
      end

      it 'returns an error with invalid attributes' do
        post '/user_block/users', params: invalid_attributes, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the current user is not an admin' do
      let(:caller_token) { encode_token({ user_id: caller.id }) }
      let(:caller_headers) { { 'Authorization' => caller_token } }
      it 'returns a permission denied error' do
        post '/user_block/users', params: valid_attributes, headers: caller_headers
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT /users/:id' do
    let(:valid_attributes) { { name: 'Updated Caller' } }
    let(:invalid_attributes) { { email: '' } }

    it 'updates the user with valid attributes' do
      put "/user_block/users/#{caller.id}", params: valid_attributes, headers: headers
      expect(response).to have_http_status(:ok)
      caller.reload
      expect(caller.name).to eq(valid_attributes[:name])
    end

    it 'returns an error with invalid attributes' do
      put "/user_block/users/#{caller.id}", params: invalid_attributes, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /users/:id' do
    it 'deletes the user' do
      expect {
        delete "/user_block/users/#{caller.id}", headers: headers
      }.to change(UserBlock::User, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end

    it 'returns 404 when deleting a non-existent user' do
      delete "/user_block/users/#{UserBlock::User.maximum(:id).to_i + 1}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
