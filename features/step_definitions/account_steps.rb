

When(/^I check VAT Enabled\?$/) do
  check 'check_vat'
end

Then(/^VAT Enabled\? should be checked$/) do
  expect(page).to have_content "Enable VAT on bills? Yes"
  expect(@account.reload.vat_enabled).to be_truthy
end

When(/^I visit the Change Email Address page$/) do
  visit edit_email_user_registration_path
end

Then(/^the Personal plan should be selected$/) do
  expect(page.find("#account_plan_id [value]").value).to eq "1"
end

When(/^I choose the Business Annual plan$/) do
  page.find("#account_plan_id [value]").set("3")
end