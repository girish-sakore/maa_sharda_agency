class ExportAllocationService
  require 'write_xlsx'

  def self.call(data)
    file_path = Rails.root.join("tmp", "allocations_#{Time.now.to_i}.xlsx")
    workbook = WriteXLSX.new(file_path)
    worksheet = workbook.add_worksheet

    # Headers
    headers = %w[ID Segment Pool Branch CustomerName EMICollected TotalCollected]
    headers.each_with_index { |header, index| worksheet.write(0, index, header) }

    # Data
    data.each_with_index do |allocation, row_index|
      worksheet.write(row_index + 1, 0, allocation.id)
      worksheet.write(row_index + 1, 1, allocation.segment)
      worksheet.write(row_index + 1, 2, allocation.pool)
      worksheet.write(row_index + 1, 3, allocation.branch)
      worksheet.write(row_index + 1, 4, allocation.customer_name)
      worksheet.write(row_index + 1, 5, allocation.emi_coll)
      worksheet.write(row_index + 1, 6, allocation.total_coll)
    end

    workbook.close
    file_path
  end
end
