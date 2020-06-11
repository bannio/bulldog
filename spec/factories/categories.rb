# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category#{n}" }
    account {nil}
  end
end
