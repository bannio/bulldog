Given(/^I visit the suppliers page$/) do
  visit '/suppliers'
end

Then(/^I should see (\d+) bills with a supplier of "(.*?)"$/) do |num, text|
  expect(all(:xpath, "//tr[td='#{text}']").count).to eq num
end