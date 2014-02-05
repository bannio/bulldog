@sign_up
Feature: Sign up
  In order to get access to protected sections of the site
  As a user
  I want to be able to sign up

  Background:
    Given I am not logged in

  Scenario: User signs up with valid data
    When I sign up with just my email
    Then I should see a successful sign up message
    And I should receive an email
    When I open the email
    Then I should see "confirm" in the email body
    When I follow "confirm" in the email
    Then I should be on the Account Activation page
    When I enter account activation details 
    Then I should see "Your account was successfully confirmed."
    And I should be on the Home page
    And I have an Account record saved
    
  Scenario: User signs up with invalid email
    When I sign up with an invalid email
    Then I should see an invalid email message

  Scenario: User activates account without password
    When I activate without a password
    Then I should see a missing password message

  Scenario: User activates account without password confirmation
    When I activate without a password confirmation
    Then I should see a missing password confirmation message

  Scenario: User acctivates account with mismatched password and confirmation
    When I activate with a mismatched password confirmation
    Then I should see a mismatched password message
