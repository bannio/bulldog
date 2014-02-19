# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :customer do
    sequence(:name) { |n| "Customer ##{n}" }
    account_id "1"
    address "MyText"
    postcode "MyString"

    # factory :customer_with_bill do
    #   after_create do |customer|
    #     create(:bill, customer: customer)
    #   end
    # end
  end
end
