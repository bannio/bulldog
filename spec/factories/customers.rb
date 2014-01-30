# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer do
    name "MyString"
    account nil
    address "MyText"
    postcode "MyString"
  end
end
