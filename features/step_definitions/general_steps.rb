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

When(/^I click on (\w+)$/) do |link|
  click_on link.first
end