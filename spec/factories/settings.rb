# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting do
    account
    name "MyString"
    address "MyText"
    postcode "MyString"
    bank_account_name "MyString"
    bank_name "MyString"
    bank_address "MyString"
    bank_account_no "MyString"
    bank_bic "MyString"
    bank_iban "MyString"
    bank_sort "MyString"
  end
end
