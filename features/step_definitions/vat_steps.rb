When(/^I visit the VAT page$/) do
  visit "/vat_rates"
end

When(/^I fill in name with "(.*?)"$/) do |name|
  fill_in 'vat_rate_name', with: name
end

When(/^I fill in rate with "(.*?)"$/) do |rate|
  fill_in 'vat_rate_rate', with: rate
end

When(/^I check active$/) do
  check 'vat_rate_active'
end

Given(/^I have an (.*?) "(.*?)" rate at (\d+)%$/) do |active, name, rate|
  isactive = active == "active" ? true : false
  vat_rate = VatRate.new(account_id: @account.id, name: name, rate: rate, active: isactive)
  vat_rate.save
end

When(/^I uncheck "active" and click Save$/) do
  uncheck 'vat_rate_active'
  click_on 'Save'
end

Then(/^the "(.*?)" rate should be inactive$/) do |name|
  expect(VatRate.find_by_name(name).active?).to be_false
end

Given(/^I have a bill using the "(.*?)" rate$/) do |rate|
  vat_rate = VatRate.find_by_name(rate)
  bill = FactoryGirl.create(:bill, account_id: @account.id, vat_rate_id: vat_rate.id)
end

When(/^I visit the Account page$/) do
  visit '/accounts/1'
end

When(/^I check Enable VAT on bills\?$/) do
  check 'check_vat'
end

When(/^I uncheck Enable VAT on bills\?$/) do
  uncheck 'check_vat'
end

Then(/^I visit the Bills page$/) do
  visit '/bills'
end

Then(/^I can select "(.*?)" from the VAT rate list$/) do |option|
  fill_in 'bill_vat_rate_id', with: option
end

Given(/^VAT is enabled$/) do
  @account.update_attribute(:vat_enabled, true)
end

Then(/^I should see (\d+) rates$/) do |num|
  expect(all("tbody#vat_rate_index_table tr").count).to eq num
end

