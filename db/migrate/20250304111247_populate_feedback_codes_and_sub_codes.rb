class PopulateFeedbackCodesAndSubCodes < ActiveRecord::Migration[7.1]
  def up
    puts "Populating database with Feedback Codes and Sub Codes (using migration)..."

    code_configurations = {
      PAID: {
        useSubCode: false,
        fields: ["amount", "remarks"],
        category: 'COMMON',
        description: "Paid"
      },
      PPD: {
        useSubCode: false,
        fields: ["amount", "next_payment_date", "remarks"],
        category: 'COMMON',
        description: "Partially Paid"
      },
      PTP: {
        useSubCode: false,
        fields: ["ptp_date", "amount"],
        category: 'COMMON',
        description: "Customer promise to pay on date"
      },
      BPTP: {
        useSubCode: false,
        fields: ["ptp_date", "amount", "remarks"],
        category: 'COMMON',
        description: "Broken Promise to Pay & given further date"
      },
      RNR: {
        useSubCode: false,
        fields: ["remarks"],
        category: 'CALLING',
        description: "Customer number is ringing"
      },
      DISC: {
        useSubCode: false,
        fields: ["remarks"],
        category: 'CALLING',
        description: "Customer is Disconnecting calls"
      },
      CLB: {
        useSubCode: false,
        fields: ["ptp_date"],
        category: 'COMMON',
        description: "Customer says to callback on Date"
      },
      SW: {
        useSubCode: false,
        fields: ["remarks"],
        category: 'CALLING',
        description: "Customer number is Switched Off"
      },
      NR: {
        useSubCode: false,
        fields: ["remarks"],
        category: 'CALLING',
        description: "Customer number not reachable"
      },
      DISPUTE: {
        useSubCode: false,
        fields: ["remarks"],
        category: 'COMMON',
        description: "Customer having dispute, Device surrendered, Dealer issue"
      },
      LMG: {
        useSubCode: false,
        fields: ["remarks"],
        category: 'COMMON',
        description: "Customer not available at home and left Message to wife/daughter/relative"
      },
      RTP: {
        useSubCode: false,
        fields: ["remarks", "ptp_date"],
        category: 'COMMON',
        description: "Customer Refused To Pay"
      },
      SET: {
        useSubCode: false,
        fields: ["settlement_amount", "settlement_date"],
        category: 'COMMON',
        description: "Customer ready to Settle the account"
      },
      SETTLED: {
        useSubCode: false,
        fields: ["settlement_amount", "settlement_date"],
        category: 'COMMON',
        description: "Customer Settled the account"
      },
      FRD: {
        useSubCode: false,
        fields: ["remarks"],
        category: 'COMMON',
        description: "Fraud"
      },
      DLK: {
        useSubCode: false,
        fields: ["remarks"],
        category: 'VISIT',
        description: "Door Lock Closed"
      },
      SHIFTED: {
        useSubCode: false,
        fields: ["new_address", "remarks"],
        category: 'VISIT',
        description: "Customer is Shifted to another address"
      },
      SKIP: {
        useSubCode: false,
        fields: ["remarks"],
        category: 'VISIT',
        description: "Customer Skiped Residence address & Permanent address"
      },
      ANF: {
        useSubCode: false,
        fields: ["remarks"],
        category: 'VISIT',
        description: "Address Not Found"
      },
      SA: {
        useSubCode: false,
        fields: ["remarks"],
        category: 'VISIT',
        description: "Short address"
      },
      WA: {
        useSubCode: false,
        fields: ["remarks"],
        category: 'VISIT',
        description: "Wrong Address"
      },
      # NC: {
      #   useSubCode: true,
      #   subCodes: {
      #       ANF: {
      #         fields: ["remarks"],
      #         description: ""
      #       },
      #       SHIFTED: {
      #         fields: ["Time Skip", "Confirmed By"],
      #         description: ""
      #       },
      #       NSP: {
      #         fields: ["remarks"],
      #         description: ""
      #       },
      #       WRONG_INCOMPLETE_ADDRESS: {
      #         fields: ["remarks"],
      #         description: ""
      #       },
      #       RING: {
      #         fields: ["remarks"],
      #         description: ""
      #       },
      #       SO: {
      #         fields: ["remarks"],
      #         description: ""
      #       },
      #       NR: {
      #         fields: ["remarks"],
      #         description: ""
      #       },
      #     },
      #   category: 'CALLING',
      #   description: "Not Connected/Customer number is wrong/Not available"
      # },
    }
    
    code_configurations.each do |code_key, config|
      feedback_code = FeedbackCode.create!(
      code: code_key.to_s.upcase,
      use_sub_code: config[:useSubCode],
      category: config[:category].to_s.upcase,
      description: config[:description] || code_key.to_s.upcase,
      fields: config[:fields]
      )
      puts "Created FeedbackCode: #{code_key.to_s.upcase} - Description: #{feedback_code.description}"

      if config[:useSubCode] && !(config[:subCodes].empty?)
        config[:subCodes].each do |sub_code_key, sub_config|
          sub_code = feedback_code.sub_codes.create!(
            sub_code: sub_code_key.to_s.upcase,
            description: sub_config[:description] || sub_code_key.to_s.downcase,
            fields: sub_config[:fields]
          )
          puts "  Created SubCode: #{sub_code_key.to_s.upcase} - Description: #{sub_code.description} for FeedbackCode: #{code_key.to_s.upcase}"
        end
      end
    end

    puts "Feedback Codes and Sub Codes populated successfully via migration!"
  end

  def down
    puts "Removing Feedback Codes and Sub Codes (migration rollback)..."
    FeedbackCode.destroy_all
    puts "Feedback Codes and Sub Codes removed."
  end
end