@account
Feature: Account
  To facilitate future subscription plans and to store information
  for invoice address etc. An account should be created after first
  sign in (following confirmation) and this should be editable.

  Background:
    Given I am not logged in

  Scenario: Sign in first time
    Given I have no account
    When I sign in with valid credentials
    Then I should be on the New Account page
    When I fill in address details and click save
    Then I should see "Account successfully created"
    And I should be on the Home page
    And I have an Account record saved

  Scenario: Sign in a second time
    Given I am a user with an account
    When I sign in
    Then I should be on the Home page

  Scenario: I can update my account address details
    Given I am a user with an account
    And  I sign in
    When I visit the home page
    And I click on Account
    And I click on Edit
    Then I should be on the Edit Account page
    When I fill in address details and click save
    Then I should see "Account successfully updated"

  Scenario: I can only see my own account
