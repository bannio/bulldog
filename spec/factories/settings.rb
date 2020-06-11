# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :setting do
    account
    name {"MyString"}
    address {"MyText"}
    postcode {"MyString"}
    bank_account_name {"MyString"}
    bank_name {"MyString"}
    bank_address {"MyString"}
    bank_account_no {"MyString"}
    bank_bic {"MyString"}
    bank_iban {"MyString"}
    bank_sort {"MyString"}
    include_vat {nil}
    include_bank {nil}
    logo_file_name {nil}
    logo_content_type {nil}
    logo_file_size {nil}
    logo_updated_at {nil}
  end
end
