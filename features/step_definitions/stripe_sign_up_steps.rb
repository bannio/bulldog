And(/^stripe-ruby-mock is running$/) do
  require 'stripe_mock'
  StripeMock.stop
  StripeMock.start
  Stripe::Plan.create(currency: "gbp",
     name: "Test",
     amount: 2000,
     interval: "year",
     interval_count: 1,
     trial_period_days: 0,
     id: 1)
end

Then(/^I should be on the Sign up form$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I enter my name and email address$/) do
  fill_in 'account_name', with: 'fred'
  fill_in 'account_email', with: 'example@example.com'
end

When(/^my credit card details$/) do
  fill_in 'card_number', with: '4242424242424242'
  fill_in 'card_code', with: '123'
  select('1 - January', from: 'card_month')
  select('2020', from: 'card_year')
end

Given(/^a Base Plan exists$/) do
  @plan = FactoryGirl.create(:plan, id: 1)
end

When(/^I Sign up for Base Plan$/) do
  within("div.signup"){click_link("Sign up")}
end

When(/^I enter (\d*), (\d*), (\d+ - \w*) and (\d*)$/) do |card_number, cvc, month, year|
  fill_in 'card_number', with: card_number.to_i
  fill_in 'card_code', with: cvc.to_i
  select(month, from: 'card_month')
  select(year.to_i.to_s, from: 'card_year')
  click_button "Subscribe"
end

When(/^I go to the new account page$/) do
  plan = Plan.first || FactoryGirl.create(:plan)
  visit new_account_path(plan_id: plan.id)
end

Then(/^I should get (.*)$/) do |result|
  expect(page).to have_content(result)
end