FactoryBot.define do
  factory :allocation_draft do
    caller { association :caller }
    executive { association :executive }
    
    segment { "Segment A" }
    pool { "Pool 1" }
    branch { "Branch X" }
    agreement_id { "AG123456" }
    customer_name { Faker::Name.name }
    pro { "PRO123" }
    bkt { "BKT001" }
    fos_name { "FOS Name" }
    fos_mobile_no { "1234567890" }
    caller_name { "Caller Name" }
    caller_mo_number { "0987654321" }
    f_code { "F123" }
    ptp_date { Date.today + 7.days }
    feedback { "Positive" }
    res { "Resolved" }
    emi_coll { 1000 }
    cbc_coll { 500 }
    total_coll { 1500 }
    fos_id { "FOS123" }
    mobile { "1234567890" }
    address { "123 Main St" }
    zipcode { "123456" }
    phone1 { "1111111111" }
    phone2 { "2222222222" }
    loan_amt { 50000 }
    pos { "POS001" }
    emi_amt { 500.50 }
    emi_od_amt { 50.75 }
    bcc_pending { "Pending" }
    penal_pending { "None" }
    cycle { 1 }
    tenure { 24 }
    disb_date { Date.today - 1.year }
    emi_start_date { Date.today - 11.months }
    emi_end_date { Date.today + 13.months }
    manufacturer_desc { "Manufacturer XYZ" }
    asset_cat { "Vehicle" }
    supplier { "Supplier ABC" }
    system_bounce_reason { "Technical Issue" }
    reference1_name { "Ref1 Name" }
    reference2_name { "Ref2 Name" }
    so_name { "SO Name" }
    ro_name { "RO Name" }
  end
end
