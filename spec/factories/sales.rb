# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sale do
    plan
    account
    state "pending"
    stripe_charge_id "MyString"
    stripe_customer_id "MyString"
    card_last4 "1234"
    card_expiration "2014-07-25"
    error "MyText"
    fee_amount 1
    email "MyString"
  end
end
