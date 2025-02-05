require 'write_xlsx'

class ExportAllocationService
  def initialize(data)
    @data = data
  end

  def call
    file_path = Rails.root.join("tmp", "allocation_drafts_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx")
    workbook = WriteXLSX.new(file_path)
    worksheet = workbook.add_worksheet("Allocation Drafts")

    # Define column headers
    headers = [
      "ID", "Segment", "Pool", "Branch", "Agreement ID", "Customer Name", "PRO", "BKT", "FOS Name",
      "FOS Mobile No", "Caller Name", "Caller Mobile Number", "F Code", "PTP Date", "Feedback", "Res",
      "EMI Collection", "CBC Collection", "Total Collection", "FOS ID", "Mobile", "Address", "Zipcode",
      "Phone1", "Phone2", "Loan Amount", "POS", "EMI Amount", "EMI OD Amount", "BCC Pending",
      "Penal Pending", "Cycle", "Tenure", "Disb Date", "EMI Start Date", "EMI End Date",
      "Manufacturer Desc", "Asset Category", "Supplier", "System Bounce Reason", "Reference1 Name",
      "Reference2 Name", "SO Name", "RO Name", "All DT", "Created At", "Updated At", "Caller ID", "Executive ID"
    ]

    # Write headers to the first row
    headers.each_with_index { |header, index| worksheet.write(0, index, header) }

    # Populate data rows
    @data.each_with_index do |record, row_index|
      worksheet.write(row_index + 1, 0, record.id)
      worksheet.write(row_index + 1, 1, record.segment)
      worksheet.write(row_index + 1, 2, record.pool)
      worksheet.write(row_index + 1, 3, record.branch)
      worksheet.write(row_index + 1, 4, record.agreement_id)
      worksheet.write(row_index + 1, 5, record.customer_name)
      worksheet.write(row_index + 1, 6, record.pro)
      worksheet.write(row_index + 1, 7, record.bkt)
      worksheet.write(row_index + 1, 8, record.fos_name)
      worksheet.write(row_index + 1, 9, record.fos_mobile_no)
      worksheet.write(row_index + 1, 10, record.caller_name)
      worksheet.write(row_index + 1, 11, record.caller_mo_number)
      worksheet.write(row_index + 1, 12, record.f_code)
      worksheet.write(row_index + 1, 13, record.ptp_date.to_s)
      worksheet.write(row_index + 1, 14, record.feedback)
      worksheet.write(row_index + 1, 15, record.res)
      worksheet.write(row_index + 1, 16, record.emi_coll)
      worksheet.write(row_index + 1, 17, record.cbc_coll)
      worksheet.write(row_index + 1, 18, record.total_coll)
      worksheet.write(row_index + 1, 19, record.fos_id)
      worksheet.write(row_index + 1, 20, record.mobile)
      worksheet.write(row_index + 1, 21, record.address)
      worksheet.write(row_index + 1, 22, record.zipcode)
      worksheet.write(row_index + 1, 23, record.phone1)
      worksheet.write(row_index + 1, 24, record.phone2)
      worksheet.write(row_index + 1, 25, record.loan_amt)
      worksheet.write(row_index + 1, 26, record.pos)
      worksheet.write(row_index + 1, 27, record.emi_amt)
      worksheet.write(row_index + 1, 28, record.emi_od_amt)
      worksheet.write(row_index + 1, 29, record.bcc_pending)
      worksheet.write(row_index + 1, 30, record.penal_pending)
      worksheet.write(row_index + 1, 31, record.cycle)
      worksheet.write(row_index + 1, 32, record.tenure)
      worksheet.write(row_index + 1, 33, record.disb_date.to_s)
      worksheet.write(row_index + 1, 34, record.emi_start_date.to_s)
      worksheet.write(row_index + 1, 35, record.emi_end_date.to_s)
      worksheet.write(row_index + 1, 36, record.manufacturer_desc)
      worksheet.write(row_index + 1, 37, record.asset_cat)
      worksheet.write(row_index + 1, 38, record.supplier)
      worksheet.write(row_index + 1, 39, record.system_bounce_reason)
      worksheet.write(row_index + 1, 40, record.reference1_name)
      worksheet.write(row_index + 1, 41, record.reference2_name)
      worksheet.write(row_index + 1, 42, record.so_name)
      worksheet.write(row_index + 1, 43, record.ro_name)
      worksheet.write(row_index + 1, 44, record.all_dt)
      worksheet.write(row_index + 1, 45, record.created_at.to_s)
      worksheet.write(row_index + 1, 46, record.updated_at.to_s)
      worksheet.write(row_index + 1, 47, record.caller_id)
      worksheet.write(row_index + 1, 48, record.executive_id)
    end

    # Close the workbook
    workbook.close

    file_path.to_s
  end
end
