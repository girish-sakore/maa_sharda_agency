require 'rails_helper'
include JwtHelper

RSpec.describe AllocationDraftsController, type: :request do
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:caller) { FactoryBot.create(:caller) }
  let!(:executive) { FactoryBot.create(:executive) }
  let(:token) { encode_token({ user_id: admin.id }) }
  let(:headers) { { 'Authorization' => token } }

  let!(:allocation_drafts) { FactoryBot.create_list(:allocation_draft, 5) }

  describe 'GET /get_allocations' do
    let(:some_allocation) { allocation_drafts.first }
    context 'successfull 1' do
      it 'returns success response' do
        get '/dashboards/get_allocations',
        params: { :q => { :customer_name_cont => some_allocation.customer_name.first(5) } },
        headers: headers
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        customer_names = parsed_response['data'].map { |allocation| allocation['customer_name'] }
        expect(customer_names).to include(some_allocation.customer_name)
        expect(parsed_response['message']).to eq('Data fetched successfully')
      end
    end
    context 'when no allocations match the query' do
      it 'returns an empty array with a message' do
        get '/dashboards/get_allocations',
            params: { :q => { :customer_name_cont => 'NonExistentName' } },
            headers: headers
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data']).to eq([])
        expect(parsed_response['message']).to eq('No allocations found')
      end
    end
    context 'when no query is given' do
      it 'returns the correct page of results' do
        get '/dashboards/get_allocations',
            params: { page: 2, per_page: 3 },
            headers: headers
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data'].size).to eq(5)
      end
    end
  end
end