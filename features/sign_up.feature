@sign_up
Feature: Sign Up to free trial
  In order to minimise onboarding friction, allow users to sign up with just
  a name and email address.

  # removed sign up option Oct 2016

# Background:
#   Given I am not logged in
#   And a Base Plan exists
#   And a Business Monthly Plan exists
#   And a Business Annual Plan exists
#   And stripe-ruby-mock is running

# Scenario: Sign Up
#   Given I visit the home page
#   When I click on Sign up
#   Then we should be on the Plans page
#   When I Sign up for Base Plan
#   Then we should be on the New Account page
#   When I enter my name and email address
#   And I click button Start Free Trial
#   Then I should be on the Thanks page
