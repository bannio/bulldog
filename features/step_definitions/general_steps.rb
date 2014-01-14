Given(/^the application exists$/) do
  true  # no set up required at this point
end

When(/^I visit the home page$/) do
  visit '/'
end

Then(/^I should see the (\w+) page$/) do |page|
  # TODO decide what to match pages on
end