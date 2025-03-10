FactoryBot.define do
  factory :feedback_code do
    code { "MyString" }
    use_sub_code { false }
    category { "MyString" }
    fields { "" }
  end
end
