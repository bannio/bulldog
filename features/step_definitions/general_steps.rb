Then(/^debug$/) do
  save_and_open_page
end

Given(/^the application exists$/) do
  true  # no set up required at this point
end

When(/^I visit the home page$/) do
  visit '/'
end

Then(/^I should be on the (\w+) page$/) do |pagename|
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

When(/^I click on (.+)$/) do |link|
  click_link(link)
end

When(/^I enter a valid email and password$/) do
  fill_in 'user_email', with: 'example@example.com'
  fill_in 'user_password', with: 'secret12'
  fill_in 'user_password_confirmation', with: 'secret12'
  click_on 'Sign Up'
end

Then(/^I should see "(.*?)"$/) do |text|
  # save_and_open_page
  # expect(page.has_content?(text)).to be_true
  page.should have_content text
end

Then(/^I should not see "(.*?)"$/) do |text|
  # save_and_open_page
  # expect(page.has_content?(text)).to be_true
  page.should_not have_content text
end