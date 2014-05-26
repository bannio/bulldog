# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    user_id 1
    name "MyString"
    vat_enabled false
    plan_id 1
    sequence(:email) { |n| "account#{n}@example.com" }
  end
end
