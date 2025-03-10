FactoryBot.define do
  factory :feedback do
    feedback_code { "MyString" }
    amount { "9.99" }
    remarks { "MyText" }
    next_payment_date { "2025-03-10" }
    ptp_date { "2025-03-10" }
    settlement_amount { "9.99" }
    settlement_date { "2025-03-10" }
    new_address { "MyString" }
  end
end
