Then(/^debug$/) do
  save_and_open_page
end

Given(/^the application exists$/) do
  true  # no set up required at this point
end

When(/^I visit the home page$/) do
  visit home_path
end

Then(/^I should be on the (.*) page$/) do |pagename|
  # assumes that content_for :title includes pagename
  # e.g. <% content_for :title do %>BulldogClip:Home<% end %>
  title.should include pagename
end

Given(/^I am not signed in$/) do
  visit '/sign_out'
end

Then(/^I should see a (.*) link$/) do |link|
  expect(page.has_link?(link)).to be_truthy
end

Then(/^I should not see a (.*) link$/) do |link|
  expect(page.has_link?(link)).to be_falsey
end

Given /^I click the first table row$/ do
  find(:xpath, "//table/tbody/tr[1]/td[1]").click
end

Given /^I click the second table row$/ do
  find(:xpath, "//table/tbody/tr[2]/td[1]").click
end

Given /^I click the third table row$/ do
  find(:xpath, "//table/tbody/tr[3]/td[1]").click
end

# click on a row with given text in any td
Given(/^I click the "(.*?)" row$/) do |txt|
  find(:xpath, "//tbody/tr[td/text()='#{txt}']").click
end

When(/^I click on (.+)$/) do |link|
  Capybara.exact = true
  find_link(link)
  click_link(link)
end

When(/^I click the (.+) link within the (.*?)$/) do |link, context|
  within(context){click_link(link)}
end

When(/^I click button (.*?)$/) do |btn|
  click_button(btn)
end

When(/^I check "(.*?)" checkbox$/) do |box|
  check box
end

When(/^I click Delete and confirm$/) do
  click_on 'Delete'
  page.driver.browser.switch_to.alert.accept
end

When(/^I click for the next page$/) do
  find('span.next a', visible: false).click
  # Note that Selenium still will not click on an invisible link
  # even if Capybara can find it.
end

# When(/^I enter a valid email and password$/) do
#   fill_in 'user_email', with: 'example@example.com'
#   fill_in 'user_password', with: 'secret12'
#   fill_in 'user_password_confirmation', with: 'secret12'
#   click_on 'Sign Up'
# end

Then(/^I should see "(.*?)"$/) do |text|
  page.should have_content text
end

Then(/^I should not see "(.*?)"$/) do |text|
  page.should_not have_content text
end

Then(/^I should see button "(.*?)"$/) do |button|
  expect(page).to have_button(button)
end

When(/^I fill in address details and click save$/) do
  fill_in 'account_name', with: 'My Name'
  fill_in 'account_address', with: 'My House\n My Street\n My Town'
  fill_in 'account_postcode', with: 'ABC 123'
  click_on 'Save'
end

Then(/^I have an Account record saved$/) do
  user = User.where(email: 'example@example.com').first
  account = Account.find_by user_id: user.id
  expect(account).to be_truthy
end

Given(/^I visit the settings page$/) do
  visit "/settings"
end

And(/^wait (\d+)$/) do |secs|
  sleep secs
end

Then(/^we should be on the Plans page$/) do
  sleep 1
  expect(current_path).to eq("/plans")
end

Then(/^we should be on the Home page$/) do
  sleep 1
  expect(current_path).to eq("/")
end

Then(/^we should be on the New Account page$/) do
  sleep 1
  expect(current_path).to eq("/accounts/new")
end

