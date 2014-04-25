@account
Feature: Account
  To facilitate future subscription plans and to store information
  for invoice address etc. An account should be created after first
  sign in (following confirmation) and this should be editable.

  Background:
    Given I am not logged in

  Scenario: Sign in first time
    Given I have no account
    And I sign up with just my email
    When I activate with a valid password
    Then I should be on the Bills page
    And I should see "Your account was successfully confirmed."
    And I have an Account record saved

  Scenario: Sign in a second time
    Given I am a user with an account
    When I sign in
    Then I should be on the Bills page

  Scenario: I can change my password
    Given I am a user with an account
    And  I sign in
    When I visit the home page
    And I click on Account
    And I click on Change Password
    Then I should be on the Change Password page

  Scenario: I can only see my own account
