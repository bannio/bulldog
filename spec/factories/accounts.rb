# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    user_id 1
    name "MyString"
    address "MyText"
    postcode "MyString"
  end
end
