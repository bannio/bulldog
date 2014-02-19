# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice do
    account_id "1"
    customer
    date "2014-02-17"
    number "MyString"
    total "9.99"
    comment "MyText"
  end
end
