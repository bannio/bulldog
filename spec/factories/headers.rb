# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :header do
    name {"MyString"}
    account {nil}
  end
end
