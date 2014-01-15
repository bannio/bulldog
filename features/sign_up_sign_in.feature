@signup
Feature: Sign Up and Sign In
  As we want people to store their personal data on the site 
  we need them to be able to sign up and sign in so that we
  know who they are

  Scenario: There is a sign up link
    Given I am not signed in
    And I visit the home page
    Then I should see a Sign Up link