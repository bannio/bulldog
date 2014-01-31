# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer do
    sequence(:name) { |n| "Customer ##{n}" }
    account
    address "MyText"
    postcode "MyString"
  end
end
