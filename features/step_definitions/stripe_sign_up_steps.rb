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
  select('January', from: 'card_month')
  select('2020', from: 'card_year')
end

Given(/^a Base Plan exists$/) do
  @plan = FactoryGirl.create(:plan, id: 1)
end

When(/^I Sign up for Base Plan$/) do
  within("div.signup"){click_link("Sign up")}
end