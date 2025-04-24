FactoryBot.define do
  factory :attendance do
    association :user, factory: :caller
    date { Date.today }
    check_in_time { Time.zone.now.change(hour: 9, min: 0) }
    check_out_time { Time.zone.now.change(hour: 18, min: 0) }
    status { "present" }
    notes { "Sample note" }
  end
end