FactoryBot.define do
  factory :user, class: 'UserBlock::User' do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { 'password' }
    type { 'UserBlock::Caller' } # Default type

    trait :admin do
      type { 'UserBlock::Admin' }
      sequence(:email) { |n| "admin#{n}@example.com" } # Unique email pattern for admins
    end

    trait :caller do
      type { 'UserBlock::Caller' }
      email { Faker::Internet.unique.email(domain: 'caller.com') } # Random email with custom domain
    end

    trait :executive do
      type { 'UserBlock::Executive' }
      email { Faker::Internet.unique.email(domain: 'executive.com') } # Random email with custom domain
    end
  end
end