FactoryBot.define do
  factory :executive, class: 'UserBlock::Executive' do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    type { 'UserBlock::Executive' }
  end
end