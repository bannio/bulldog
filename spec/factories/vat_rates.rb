# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :vat_rate do
    account
    name {"Standard"}
    rate {"20"}
    active {true}
  end
end
