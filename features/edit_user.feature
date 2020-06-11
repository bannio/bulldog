
@edit_account
Feature: Edit User Account
  As a registered user of the website
  I can change my password and/or my email

  Background:
    Given I am a user with an account
    # And stripe-ruby-mock is running
    # And the account has a valid Stripe Customer token
    And I sign in

  Scenario: I sign in and edit my account password
    When I edit my account details
    Then I should see a request to log in
    # Then I should see an account edited message

  Scenario: I can change my email
    When I edit my account and change the email to "new@example.com"
    Then I should see an account edited message
    And "new@example.com" should receive an email
    When I open the email
    Then I should see "confirm" in the email body
    Then I should see "You updated your account successfully"
    When I follow "confirm" in the email
    Then I should see "Your account was successfully confirmed"
