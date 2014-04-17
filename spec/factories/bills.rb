# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bill do
    account_id "1"
    date "2014-01-01"
    customer_id "1"
    supplier
    category
    description "MyText"
    amount "1"
    invoice_id ""
    vat ""
    vat_rate_id ""
  end
end
