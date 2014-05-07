# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    user
    name "MyString"
    vat_enabled false
  end
end
