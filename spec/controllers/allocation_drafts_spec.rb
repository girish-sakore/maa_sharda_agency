require 'rails_helper'
include JwtHelper

 RSpec.describe AllocationDraftsController, type: :request do
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:caller) { FactoryBot.create(:caller) }
  let!(:executive) { FactoryBot.create(:executive) }
  let(:token) { encode_token({ user_id: admin.id }) }
  let(:headers) { { 'Authorization' => token } }

  let(:allocation_drafts) { FactoryBot.create_list(:allocation_draft, 5) }
  # let(:valid_file_path) do
  #   Tempfile.new(['test', '.xlsx']).tap do |file|
  #     workbook = WriteXLSX.new(file.path)
  #     worksheet = workbook.add_worksheet

  #     worksheet.write_row(0, 0, ["Segment", "Pool", "Branch", "Agreement ID", "Customer Name", "Pro", "BKT", "FOS Name", "FOS Mobile No", "Caller Name", "Caller Mo Number", "F Code", "PTP Date", "Feedback", "RES", "EMI Coll", "CBC Coll", "Total Coll", "FOS ID", "Mobile", "Address", "Zipcode", "Phone1", "Phone2", "Loan Amt", "POS", "EMI Amt", "EMI OD Amt", "BCC Pending", "Penal Pending", "Cycle", "Tenure", "Disb Date", "EMI Start Date", "EMI End Date", "Manufacturer Desc", "Asset Cat", "Supplier", "System Bounce Reason", "Reference1 Name", "Reference2 Name", "SO Name", "RO Name", "All DT"])
  #     worksheet.write_row(1, 0, ["Segment1", "Pool1", "Branch1", "AG001", "John Doe", "Pro1", "BKT1", "FOS1", "1234567890", "Caller1", "9876543210", "FC001", "10-Jan-23", "Positive", "Res1", "5000", "2000", "7000", "FOS001", "0987654321", "123 Main St", "12345", "1112223334", "5556667778", "100000", "50000", "2000", "500", "1000", "100", "12", "15-Jan-20", "15-Feb-20", "15-Mar-20", "Desc1", "Cat1", "Supplier1", "Reason1", "Ref1", "Ref2", "SO1", "RO1", "AllData1"])
  #     workbook.close
  #   end
  # end
  # let(:invalid_file_path) do
  #   Tempfile.new(['invalid_test', '.xlsx']).tap do |file|
  #     workbook = WriteXLSX.new(file.path)
  #     worksheet = workbook.add_worksheet
  #     worksheet.write_row(0, 0, ["Segment", "Pool", "Branch", "Agreement ID", "Customer Name", "Pro", "BKT", "FOS Name", "FOS Mobile No", "Caller Name", "Caller Mo Number", "F Code", "PTP Date", "Feedback", "RES", "EMI Coll", "CBC Coll", "Total Coll", "FOS ID", "Mobile", "Address", "Zipcode", "Phone1", "Phone2", "Loan Amt", "POS", "EMI Amt", "EMI OD Amt", "BCC Pending", "Penal Pending", "Cycle", "Tenure", "Disb Date", "EMI Start Date", "EMI End Date", "Manufacturer Desc", "Asset Cat", "Supplier", "System Bounce Reason", "Reference1 Name", "Reference2 Name", "SO Name", "RO Name", "All DT"])
  #     worksheet.write_row(1, 0, ["Invalid", "Data", "Only"])
  #     workbook.close
  #   end
  # end
  describe 'POST /import_allocation' do
    context 'when file is provided and import is successful' do
      it 'returns success response' do
        allow_any_instance_of(ImportAllocationService).to receive(:import).and_return([[], ['row 1']])

        post '/allocation_drafts/import_allocation', params: { file: 'path/to/file' }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['notice']).to eq('Data imported successfully!')
      end
    end

    context 'when file import has errors' do
      it 'returns error response with details' do
        allow_any_instance_of(ImportAllocationService).to receive(:import).and_return([
          [{ "row 1" => "Error message" }], []
        ])

        post '/allocation_drafts/import_allocation', params: { file: 'path/to/file' }, headers: headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['errors']).not_to be_empty
      end
    end

    context 'when an exception occurs' do
      it 'returns an error response' do
        allow_any_instance_of(ImportAllocationService).to receive(:import).and_raise(StandardError, 'Unexpected error')

        post '/allocation_drafts/import_allocation', params: { file: 'path/to/file' }, headers: headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Import failed')
      end
    end
  end

  describe 'GET /allocation_drafts' do
    it 'returns paginated allocation drafts with metadata' do
      allocation_drafts
      get '/allocation_drafts', params: { page: 1, per_page: 2 }, headers: headers

      expect(response).to have_http_status(:ok)
      response_body = JSON.parse(response.body)
      expect(response_body['metadata']['total']).to eq(allocation_drafts.count)
      expect(response_body['data'].size).to eq(2)
    end
  end

  describe 'POST /allocation_drafts/assign_caller' do
    context 'with valid caller and allocation drafts' do
      it 'assigns caller to allocation drafts' do
        post '/allocation_drafts/assign_caller', params: {
          caller_id: caller.id,
          allocation_draft_ids: allocation_drafts.map(&:id)
        }, headers: headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['message']).to eq('Caller assigned with some conditions')
        expect(response_body['not_found']).to be_empty
      end
    end

    context 'with invalid caller' do
      it 'returns an error response' do
        post '/allocation_drafts/assign_caller', params: { caller_id: 9999, allocation_draft_ids: allocation_drafts.map(&:id) }, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Caller not found')
      end
    end

    context 'with invalid allocation draft ids' do
      it 'returns an error message' do
        post '/allocation_drafts/assign_caller', params: { caller_id: caller.id, allocation_draft_ids: [1,2,3,4] }, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('No valid AllocationDrafts found with the given IDs')
      end
    end

    context 'without caller id' do
      it 'returns an error message' do
        post '/allocation_drafts/assign_caller', headers: headers

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Caller ID and Allocation Draft IDs are required')
      end
    end
  end

  describe 'POST /allocation_drafts/assign_executive' do
    context 'with valid executive and allocation drafts' do
      it 'assigns executive to allocation drafts' do
        post '/allocation_drafts/assign_executive', params: {
          executive_id: executive.id,
          allocation_draft_ids: allocation_drafts.map(&:id)
        }, headers: headers

        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['message']).to eq('Executive assigned with some conditions')
        expect(response_body['not_found']).to be_empty
      end
    end

    context 'with invalid executive' do
      it 'returns an error response' do
        post '/allocation_drafts/assign_executive', params: { executive_id: 9999, allocation_draft_ids: allocation_drafts.map(&:id) }, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Executive not found')
      end
    end

    context 'with invalid allocation draft' do
      it 'returns an error message' do
        post '/allocation_drafts/assign_executive', params: { executive_id: executive.id, allocation_draft_ids: [1,2,3,4] }, headers: headers

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('No valid AllocationDrafts found with the given IDs')
      end
    end

    context 'without executive id' do
      it 'returns an error message' do
        post '/allocation_drafts/assign_executive', headers: headers

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)['error']).to eq('Executive ID and Allocation Draft IDs are required')
      end
    end
  end
end
