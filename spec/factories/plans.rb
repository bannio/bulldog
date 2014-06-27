# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    name "Base Plan"
    amount 2000
    interval "year"
    description {{head: "header", bullets: ["one","two"]}}
  end
end
