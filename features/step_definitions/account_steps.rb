When(/^I check VAT Enabled\?$/) do
  check 'check_vat'
end

Then(/^VAT Enabled\? should be checked$/) do
  expect(page).to have_content "Enable VAT on bills?Yes"
  expect(@account.reload.vat_enabled).to be_true
end