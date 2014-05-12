@welcome
Feature: Welcome
  In order to provide a landing page for users

  Scenario: there is a homepage
    Given I am a user with an account
    And I am not signed in 
    And I visit the signed in homepage
    Then I should see "You need to sign in or sign up before continuing"
    When I sign in 
    Then I should see the signed in homepage