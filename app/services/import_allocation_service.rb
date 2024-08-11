
class ImportAllocationService
  require 'roo'

  def initialize(file_path)
    @file_path = file_path
  end

  def import
    errors = []
    success = []

    excel = Roo::Excelx.new(@file_path)
    (2..excel.last_row).each do |i|
      row = excel.row(i)
      begin
        AllocationDraft.create!(
          segment: row[0],
          pool: row[1],
          branch: row[2],
          agreement_id: row[3],
          customer_name: row[4],
          pro: row[5],
          bkt: row[6],
          fos_name: row[7],
          fos_mobile_no: row[8],
          caller_name: row[9],
          caller_mo_number: row[10],
          f_code: row[11],
          ptp_date: parse_date(row[12]),
          feedback: row[13],
          res: row[14],
          emi_coll: row[15],
          cbc_coll: row[16],
          total_coll: row[17],
          fos_id: row[18],
          mobile: row[19],
          address: row[20],
          zipcode: row[21],
          phone1: row[22],
          phone2: row[23],
          loan_amt: row[24],
          pos: row[25],
          emi_amt: row[26],
          emi_od_amt: row[27],
          bcc_pending: row[28],
          penal_pending: row[29],
          cycle: row[30],
          tenure: row[31],
          disb_date: parse_date(row[32]),
          emi_start_date: parse_date(row[33]),
          emi_end_date: parse_date(row[34]),
          manufacturer_desc: row[35],
          asset_cat: row[36],
          supplier: row[37],
          system_bounce_reason: row[38],
          reference1_name: row[39],
          reference2_name: row[40],
          so_name: row[41],
          ro_name: row[42],
          all_dt: row[43]
        )
        success << { "row #{i}" => "Success" }
      rescue => e
        errors << { "row #{i}" => e.message }
      end
    end
    [errors, success]
  end

  def parse_date(date_str)
    Date.strptime(date_str, "%d-%b-%y") rescue nil
  end
end
