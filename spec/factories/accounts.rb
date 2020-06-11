# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :account do
    user_id {1}
    name {"MyString"}
    vat_enabled {false}
    plan_id {1}
    sequence(:email) { |n| "account#{n}@example.com" }
    stripe_customer_token {"cust_token"}
    card_last4       {nil}
    card_expiration  {nil}
    next_invoice     {nil}
    date_reminded    {nil}
    state            {"paid"}
    trial_end       { Time.now + 1.day}
  end
end
