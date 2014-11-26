And(/^stripe-ruby-mock is running$/) do
  require 'stripe_mock'
  StripeMock.stop
  StripeMock.start
  # StripeMock.toggle_debug(true)
  Rails.logger.info "Creating Stripe Plan 1"
  Stripe::Plan.create(currency: "gbp",
     name: "Personal Test",
     amount: 1000,
     interval: "year",
     interval_count: 1,
     trial_period_days: 1,
     id: "1")
  Rails.logger.info "Creating Stripe Plan 2"
  Stripe::Plan.create(currency: "gbp",
     name: "Business Monthly Test",
     amount: 500,
     interval: "month",
     interval_count: 1,
     trial_period_days: 1,
     id: "2")
  Rails.logger.info "Creating Stripe Plan 3"
  Stripe::Plan.create(currency: "gbp",
     name: "Business Annual test",
     amount: 5000,
     interval: "year",
     interval_count: 1,
     trial_period_days: 1,
     id: "3")
end

Then(/^I should be on the Sign up form$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I enter my name and email address$/) do
  fill_in 'account_name', with: 'fred'
  fill_in 'account_email', with: 'example@example.com'
end

When(/^my credit card details$/) do
  # fill_in 'card_number', with: '4242424242424242'
  page.execute_script("$('#card_number').val('4242424242424242')")
  page.execute_script("$('#cc_exp').val('01 / 2020')")
  # find('#card_number').set("4242424242424242")
  fill_in 'card_code', with: '123'
  # fill_in 'cc_exp', with: '01/20'
  # select('1 - January', from: 'card_month')
  # select('2020', from: 'card_year')
end

Given(/^a Base Plan exists$/) do
  @plan = FactoryGirl.create(:plan,
    id:       1,
    name:     "Personal",
    interval: "year",
    amount:   1000
    )
end

Given(/^a Business Monthly Plan exists$/) do
  @plan = FactoryGirl.create(:plan,
    id:       2,
    name:     "Business Monthly",
    interval: "month",
    amount:   500
    )
end

Given(/^a Business Annual Plan exists$/) do
  @plan = FactoryGirl.create(:plan,
    id:       3,
    name:     "Business Annual",
    interval: "year",
    amount:   5000
    )
end

Given(/^the account has a valid Stripe Customer token$/) do
  @account.update_attribute(:stripe_customer_token, "cust_token")
  customer = Stripe::Customer.create({
      id:     'cust_token',
      email: 'cucumber@example.com',
      # card: 'void_card_token',
      plan: 1
    })
end

When(/^I Sign up for Base Plan$/) do
  within("div.personal"){click_link("START FREE TRIAL")}
end

When(/^I enter (\d+), (.*) and (\d+ \/ \d+)$/) do |card_number, cvc, expiry|
  card = card_number.to_i.to_s
  card = card[0..3] + ' ' + card[4..7] + ' ' + card[8..11] + ' ' + card[12..15]
  page.execute_script("$('#card_number').val('#{card}')")
  page.execute_script("$('#cc_exp').val('#{expiry}')")
  fill_in 'card_code', with: cvc.to_i
  click_button "Subscribe"
end

When(/^I go to the new account page$/) do
  plan = Plan.first || FactoryGirl.create(:plan)
  visit new_account_path(plan_id: plan.id)
end

Then(/^I should get (.*)$/) do |result|
  expect(page).to have_content(result)
end

When(/^I use a card that will be declined$/) do
  StripeMock.prepare_card_error(:card_declined)
end

Then(/^I use a card that is valid$/) do

end

When(/^I visit the Manage Subscription page$/) do
  visit account_path(@account)
end

When(/^I enter new card expiry "(.*)"$/) do |date|
  page.execute_script("$('#card_number').val('4242424242424242')")
  page.execute_script("$('#cc_exp').val('#{date}')")
  fill_in 'card_code', with: '123'
  click_button "Update Card"
end

And(/^My account has the expiry date "(.*)"$/) do |date|
  expect(@account.card_expiration).to eq date.to_date
end