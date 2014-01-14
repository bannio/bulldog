Given(/^the application exists$/) do
  true  # no set up required at this point
end

When(/^I visit the home page$/) do
  visit("/")
end

Then(/^I should see the home page$/) do
  pending # express the regexp above with the code you wish you had
end