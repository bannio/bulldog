# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill do
    account
    date "2014-01-01"
    customer
    supplier
    category
    description "MyText"
    amount "1"
  end
end
