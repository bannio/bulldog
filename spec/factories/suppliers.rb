# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :supplier do
    sequence(:name) { |n| "Supplier#{n}" }
    account {nil}
  end
end
