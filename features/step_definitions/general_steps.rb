Then(/^debug$/) do
  save_and_open_page
end

Given(/^the application exists$/) do
  true  # no set up required at this point
end

When(/^I visit the home page$/) do
  visit '/'
end

Then(/^I should be on the (.*) page$/) do |pagename|
  # assumes that content_for :title includes pagename
  # e.g. <% content_for :title do %>Bulldog-Clip:Home<% end %>
  title.should include pagename
end

Given(/^I am not signed in$/) do
  visit '/users/sign_out'
end

Then(/^I should see a (.*) link$/) do |link|
  expect(page.has_link?(link)).to be_true
end

Then(/^I should not see a (.*) link$/) do |link|
  expect(page.has_link?(link)).to be_false
end

Given /^I click the first table row$/ do
  find(:xpath, "//table/tbody/tr[1]").click 
end

Given /^I click the second table row$/ do
  find(:xpath, "//table/tbody/tr[2]").click 
end

Given /^I click the third table row$/ do
  find(:xpath, "//table/tbody/tr[3]").click 
end

When(/^I click on (.+)$/) do |link|
  find_link(link)
  click_link(link)
end

When(/^I click the (.+) link within the (.*?)$/) do |link, context|
  within(context){click_link(link)}
end

When(/^I click button (.*?)$/) do |btn|
  click_button(btn)
end

When(/^I click Delete and confirm$/) do
  click_on 'Delete'
  page.driver.browser.switch_to.alert.accept
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

When(/^I fill in address details and click save$/) do
  fill_in 'account_name', with: 'My Name'
  fill_in 'account_address', with: 'My House\n My Street\n My Town'
  fill_in 'account_postcode', with: 'ABC 123'
  click_on 'Save'
end

Then(/^I have an Account record saved$/) do
  find_user
  account = Account.find_by user_id: @user.id
  expect(account).to be_true
end

When(/^I fill in customer details and click save$/) do
  fill_in 'customer_name', with: 'My Customer'
  fill_in 'customer_address', with: 'My House\n My Street\n My Town'
  fill_in 'customer_postcode', with: 'ABC 123'
  click_on 'Save'
end

Then(/^I should have a Customer record saved$/) do
  customer = Customer.find_by account_id: @account.id
  expect(customer).to be_true
end

Given(/^I have a customer$/) do
  create_customer
end

Given(/^I visit the Customers page$/) do
  visit '/customers'
end

Given(/^There is another account with a customer$/) do
  create_another_customer
end

Then(/^I should only see my customer$/) do
  page.should_not have_content 'Another'
end

Given(/^I type the other customers ID in the edit URL$/) do
  id = @another_customer.id
  visit "/customers/#{id}/edit"
end

Given(/^I visit the settings page$/) do
  visit "/settings"
end
