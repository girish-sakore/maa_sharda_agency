class PopulateFeedbackCodesAndSubCodes < ActiveRecord::Migration[7.1] # Or your Rails version
  def up
    puts "Populating database with Feedback Codes and Sub Codes (using migration)..."

    code_configurations = {
      PAID: {
        useSubCode: false,
        fields: ["Paid Amount", "Remarks"],
        category: 'BOTH',
        description: "Paid"
      },
      PPD: {
        useSubCode: false,
        fields: ["Amount", "Next Payment Date", "Remarks"],
        category: 'BOTH',
        description: "Partially Paid"
      },
      PTP: {
        useSubCode: false,
        fields: ["Promise to Pay Date", "Amount"],
        category: 'BOTH',
        description: "Customer promise to pay on date"
      },
      BPTP: {
        useSubCode: false,
        fields: ["Promise to Pay Date", "Amount", "Remarks"],
        category: 'BOTH',
        description: "Broken Promise to Pay & given further date"
      },
      RNR: {
        useSubCode: false,
        fields: ["Remarks"],
        category: 'CALLING',
        description: "Customer number is ringing"
      },
      DISC: {
        useSubCode: false,
        fields: ["Remarks"],
        category: 'CALLING',
        description: "Customer is Disconnecting calls"
      },
      CLB: {
        useSubCode: false,
        fields: ["Callback Date"],
        category: 'BOTH',
        description: "Customer says to callback on Date"
      },
      SW: {
        useSubCode: false,
        fields: ["Remarks"],
        category: 'CALLING',
        description: "Customer number is Switched Off"
      },
      NR: {
        useSubCode: false,
        fields: ["Remarks"],
        category: 'CALLING',
        description: "Customer number not reachable"
      },
      # NC: {
      #   useSubCode: true,
      #   subCodeOptions: {
      #     "ANF": ["Remarks"],
      #     "SKIP/SHIFTED": ["Time Skip", "Confirmed By"],
      #     "NSP": ["Remarks"],
      #     "WRONG/INCOMPLETE ADDRESS": ["Remarks"],
      #     "RING": ["Calling Remarks"],
      #     "SO": ["Calling Remarks"],
      #     "NR": ["Calling Remarks"],
      #   },
      #   category: 'CALLING',
      #   description: "Not Connected/Customer number is wrong/Not available"
      # },
      DISPUTE: {
        useSubCode: false,
        fields: ["Dispute Details"],
        category: 'BOTH',
        description: "Customer having dispute, Device surrendered, Dealer issue"
      },
      LMG: {
        useSubCode: false,
        fields: ["Remarks"],
        category: 'BOTH',
        description: "Customer not available at home and left Message to wife/daughter/relative"
      },
      RTP: {
        useSubCode: false,
        fields: ["Detailed Feedback", "PTP Date"],
        category: 'BOTH',
        description: "Customer Refused To Pay"
      },
      SET: {
        useSubCode: false,
        fields: ["Settlement Amount", "Settlement Date"],
        category: 'BOTH',
        description: "Customer ready to Settle the account"
      },
      SETTLED: {
        useSubCode: false,
        fields: ["Settlement Amount", "Settled Date"],
        category: 'BOTH',
        description: "Customer Settled the account"
      },
      FRD: {
        useSubCode: false,
        fields: ["Details"],
        category: 'BOTH',
        description: "Fraud"
      },
      # WIP: {
      #   useSubCode: true,
      #   subCodeOptions: {
      #     "CB": ["Callback Date/Time"],
      #     "LM": ["Left Message To"],
      #     "HLK": ["Lock Details"],
      #     "OST": ["Out of Station Details"],
      #     "Settlement": ["Settlement Details"],
      #     "BPTP": ["Reason", "Next PTP Date"],
      #   },
      #   category: 'CALLING',
      #   description: "************"
      # },
      DLK: {
        useSubCode: false,
        fields: ["Door Lock Details"],
        category: 'VISIT',
        description: "Door Lock Closed"
      },
      SHIFTED: {
        useSubCode: false,
        fields: ["New Address", "Remarks"],
        category: 'VISIT',
        description: "Customer is Shifted to another address"
      },
      SKIP: {
        useSubCode: false,
        fields: ["Visit Details"],
        category: 'VISIT',
        description: "Customer Skiped Residence address & Permanent address"
      },
      ANF: {
        useSubCode: false,
        fields: ["Remarks"],
        category: 'VISIT',
        description: "Address Not Found"
      },
      SA: {
        useSubCode: false,
        fields: ["Remarks"],
        category: 'VISIT',
        description: "Short address"
      },
      WA: {
        useSubCode: false,
        fields: ["Remarks"],
        category: 'VISIT',
        description: "Wrong Address"
      },
    }

    code_configurations.each do |code_key, config|
      feedback_code = FeedbackCode.create!( # Use create! here for migration
        code: code_key.to_s.upcase,
        use_sub_code: config[:useSubCode],
        category: config[:category].to_s.upcase,
        description: config[:description] || code_key.to_s.upcase,
        fields: config[:fields]
      )
      puts "Created FeedbackCode: #{code_key.to_s.upcase} - Description: #{feedback_code.description}"

      if config[:useSubCode] && config[:subCodeOptions]
        config[:subCodeOptions].each do |sub_code_key, sub_code_fields|
          sub_code = feedback_code.feedback_sub_codes.create!( # Use create! here for migration
            sub_code: sub_code_key.to_s.upcase,
            description: sub_code_key.to_s.downcase,
            fields: sub_code_fields
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