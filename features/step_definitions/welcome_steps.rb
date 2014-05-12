Then(/^I should see the signed in homepage$/) do
  title.should include "Welcome"
end

When(/^I visit the signed in homepage$/) do
  visit '/welcome'
end