require 'rails_helper'
require 'tempfile'
require 'write_xlsx'

RSpec.describe ImportAllocationService do
  let(:valid_file_path) do
    Tempfile.new(['test', '.xlsx']).tap do |file|
      workbook = WriteXLSX.new(file.path)
      worksheet = workbook.add_worksheet

      worksheet.write_row(0, 0, ["Segment", "Pool", "Branch", "Agreement ID", "Customer Name", "Pro", "BKT", "FOS Name", "FOS Mobile No", "Caller Name", "Caller Mo Number", "F Code", "PTP Date", "Feedback", "RES", "EMI Coll", "CBC Coll", "Total Coll", "FOS ID", "Mobile", "Address", "Zipcode", "Phone1", "Phone2", "Loan Amt", "POS", "EMI Amt", "EMI OD Amt", "BCC Pending", "Penal Pending", "Cycle", "Tenure", "Disb Date", "EMI Start Date", "EMI End Date", "Manufacturer Desc", "Asset Cat", "Supplier", "System Bounce Reason", "Reference1 Name", "Reference2 Name", "SO Name", "RO Name", "All DT"])
      worksheet.write_row(1, 0, ["Segment1", "Pool1", "Branch1", "AG001", "John Doe", "Pro1", "BKT1", "FOS1", "1234567890", "Caller1", "9876543210", "FC001", "10-Jan-23", "Positive", "Res1", "5000", "2000", "7000", "FOS001", "0987654321", "123 Main St", "12345", "1112223334", "5556667778", "100000", "50000", "2000", "500", "1000", "100", "12", "15-Jan-20", "15-Feb-20", "15-Mar-20", "Desc1", "Cat1", "Supplier1", "Reason1", "Ref1", "Ref2", "SO1", "RO1", "AllData1"])
      workbook.close
    end
  end

  let(:invalid_file_path) do
    Tempfile.new(['invalid_test', '.xlsx']).tap do |file|
      workbook = WriteXLSX.new(file.path)
      worksheet = workbook.add_worksheet
      worksheet.write_row(0, 0, ["Segment", "Pool", "Branch", "Agreement ID", "Customer Name", "Pro", "BKT", "FOS Name", "FOS Mobile No", "Caller Name", "Caller Mo Number", "F Code", "PTP Date", "Feedback", "RES", "EMI Coll", "CBC Coll", "Total Coll", "FOS ID", "Mobile", "Address", "Zipcode", "Phone1", "Phone2", "Loan Amt", "POS", "EMI Amt", "EMI OD Amt", "BCC Pending", "Penal Pending", "Cycle", "Tenure", "Disb Date", "EMI Start Date", "EMI End Date", "Manufacturer Desc", "Asset Cat", "Supplier", "System Bounce Reason", "Reference1 Name", "Reference2 Name", "SO Name", "RO Name", "All DT"])
      worksheet.write_row(1, 0, ["Invalid", "Data", "Only"])
      workbook.close
    end
  end

  after do
    valid_file_path.close!
    invalid_file_path.close!
  end

  describe '#import' do
    context 'when the file has valid data' do
      it 'imports data successfully' do
        service = ImportAllocationService.new(valid_file_path.path)
        errors, success = service.import

        expect(errors).to be_empty
        expect(success).not_to be_empty
        expect(success.first.keys.first).to include('row 2')
        expect(AllocationDraft.count).to eq(1)
      end
    end

    context 'when the file has invalid data' do
      it 'captures the errors and does not import invalid rows' do
        service = ImportAllocationService.new(invalid_file_path.path)
        errors, success = service.import

        expect(success).to be_empty
        expect(errors).not_to be_empty
        expect(errors.first.keys.first).to include('row 2')
        expect(AllocationDraft.count).to eq(0)
      end
    end

    context 'when the file path is invalid' do
      it 'raises an error' do
        expect {
          ImportAllocationService.new('nonexistent_file.xlsx').import
        }.to raise_error(Errno::ENOENT)
      end
    end

    context 'when date parsing fails' do
      it 'handles the failure gracefully' do
        invalid_date_path = Tempfile.new(['invalid_date_test', '.xlsx']).tap do |file|
          workbook = WriteXLSX.new(file.path)
          worksheet = workbook.add_worksheet

          worksheet.write_row(0, 0, ["Segment", "Pool", "Branch", "Agreement ID", "Customer Name", "Pro", "BKT", "FOS Name", "FOS Mobile No", "Caller Name", "Caller Mo Number", "F Code", "PTP Date", "Feedback", "RES", "EMI Coll", "CBC Coll", "Total Coll", "FOS ID", "Mobile", "Address", "Zipcode", "Phone1", "Phone2", "Loan Amt", "POS", "EMI Amt", "EMI OD Amt", "BCC Pending", "Penal Pending", "Cycle", "Tenure", "Disb Date", "EMI Start Date", "EMI End Date", "Manufacturer Desc", "Asset Cat", "Supplier", "System Bounce Reason", "Reference1 Name", "Reference2 Name", "SO Name", "RO Name", "All DT"])
          worksheet.write_row(1, 0, ["Segment1", "Pool1", "Branch1", "AG001", "John Doe", "Pro1", "BKT1", "FOS1", "1234567890", "Caller1", "9876543210", "FC001", "invalid-date", "Positive", "Res1", "5000", "2000", "7000", "FOS001", "0987654321", "123 Main St", "12345", "1112223334", "5556667778", "100000", "50000", "2000", "500", "1000", "100", "12", "invalid-date", "invalid-date", "invalid-date", "Desc1", "Cat1", "Supplier1", "Reason1", "Ref1", "Ref2", "SO1", "RO1", "AllData1"])
          workbook.close
        end

        service = ImportAllocationService.new(invalid_date_path.path)
        errors, success = service.import

        expect(success).not_to be_empty
        expect(errors).to be_empty
        expect(AllocationDraft.last.emi_start_date).to eq(nil)
        expect(AllocationDraft.count).to eq(1)

        invalid_date_path.close!
      end
    end
  end
end
