Given(/^I visit the categories page$/) do
  visit '/categories'
end

Then(/^I should see (\d+) categories$/) do |num|
  expect(all("table#categories_table tr").count - 1).to eq num
end

Then (/^I should see "(.*?)" within the (.*?) field$/) do |text, field|
  expect(find_field(field).value).to eq text
end

Given (/^I visit the edit page for "(.*?)"$/) do |name|
  id = Category.find_by_name(name).id
  visit "/categories/#{id}/edit"
end

Given(/^I enter "(.*?)" in the (.*?) field and click Save$/) do |text, field|
  fill_in field, with: text
  click_on 'Save'
end

Then(/^I should see (\d+) bills with a category of "(.*?)"$/) do |num, text|
  expect(all(:xpath, "//tr[td='#{text}']").count).to eq num
end
