FactoryBot.define do
  factory :caller, class: 'UserBlock::Caller' do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    type { 'UserBlock::Caller' }
  end
end