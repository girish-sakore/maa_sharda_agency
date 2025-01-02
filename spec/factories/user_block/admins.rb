FactoryBot.define do
  factory :admin, class: 'UserBlock::Admin' do
    name { Faker::Name.name }
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { 'password' }
    type { 'UserBlock::Admin' }
  end
end