When(/^I select a date range$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I should find (\d+) bills$/) do |bills|
  # expect(all("tr").count).to eq bills
  # expect(within("tbody#report_bills") {all("tr", visible: false).count}).to eq bills
  expect(all("table#bill_table tr", visible: false).count - 1).to eq bills
end

Given(/^I visit the Analysis page$/) do
  visit '/reports/new'
end

Given(/^I select "(.*?)" as start date$/) do |date|
  fill_in 'report_from_date', with: date
end

Given(/^I select "(.*?)" as end date$/) do |date|
  fill_in 'report_to_date', with: date
end

# version that works without JS
Given(/^I select "(.*?)" as the customer$/) do |customer|
  select customer, from:'report_customer_id'
end

# version that works with JS i.e. select2 enabled
Given(/^I select "(.*?)" as customer$/) do |customer|
  page.find_by_id("select2-report_customer_id-container" ).click
  find('.select2-dropdown input.select2-search__field').send_keys("#{customer}", :enter)
  # previously:
  # select customer, from:'report_customer_id'
end

Given(/^I select "(.*?)" as supplier$/) do |supplier|
  select supplier, from: 'report_supplier_id'
end

Given(/^I select "(.*?)" from category$/) do |category|
  select category, from: 'report_category_id'
end

Then(/^I should not see "(.*?)" in the table$/) do |text|
  # within(:xpath, "//table/tbody") do
  within("table#bill_table", visible: false) do
    expect(page).to_not have_content text
  end
end

Then(/^I should see "(.*?)" in the table$/) do |text|
  # within(:xpath, "//table/tbody") do
  within("table#bill_table", visible: false) do
    expect(page).to have_content text
  end
end
