# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :invoice do
    account_id          {"1"}
    association :customer, factory: :customer_with_bill
    date                {"2014-02-17"}
    sequence(:number) {|n| "#{n}"}
    total               {"9.99"}
    comment             {"MyText"}
    header_id           {"1"}
    include_bank        {false}
    include_vat         {false}
  end
end
