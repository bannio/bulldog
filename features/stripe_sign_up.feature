@stripe_sign_up
Feature: Sign up
  In order to get access to protected sections of the site
  As a user
  I want to be able to sign up
  # NOTE stripe-ruby-mock needs work. It doesn't currently intercept createToken
  # Without it, all calls go to stripe.com

  Background:
    Given I am not logged in
    And a Base Plan exists
    And no emails have been sent
    And stripe-ruby-mock is running

  @javascript
  Scenario: User signs up with valid data
    When I visit the home page
    When I click on Sign up
    Then we should be on the Plans page
    When I Sign up for Base Plan
    Then we should be on the New Account page
    When I enter my name and email address
    # And my credit card details
    And I click button Subscribe Now
    # Then I should see "Thanks for subscribing."
    Then I should be on the Thanks page
    Then I should receive an email
    When I open the email
    Then I should see "confirm" in the email body
    When I follow "confirm" in the email
    Then I should be on the Account Activation page
    When I enter account activation details
    Then I should see "Your account was successfully confirmed."
    And I should be on the Welcome page
    And I have an Account record saved

  @javascript
  Scenario: User signs up with invalid email
    When I sign up with an invalid email
    Then I should see an invalid email message
  @javascript
  Scenario: User signs up without a name
    When I sign up without a name
    Then I should see a missing name message

  Scenario: User activates account without password
    When I activate without a password
    Then I should see a missing password message

  Scenario: User activates account without password confirmation
    When I activate without a password confirmation
    Then I should see a missing password confirmation message

  Scenario: User activates account with mismatched password and confirmation
    When I activate with a mismatched password confirmation
    Then I should see a mismatched password message

  @javascript @wip
  Scenario Outline: User enters an invalid credit card number
    Note that the dates and years will go out of date. Need to find a better way.
    The form prevents years in the past.
    This test uses card numbers provided by Stripe so only works when internet
    connected and stripe-ruby-mock is not run. Hence marked as @wip
    When I go to the new account page
    And I enter my name and email address
    And I enter <card_no>, <cvc> and <expiry>
    Then I should get <result>

    Examples:
      | card_no          | cvc | expiry  | result       |
      | 4242424242424242 | 123 | 01 / 14 | Your card's expiration month is invalid |
      | 4242424242424242 | 1   | 12 / 16 | Your card's security code is invalid   |
      | 4242424242424242 |     | 12 / 16 | Your card's security code is invalid   |
      | 4000000000000002 | 123 | 12 / 16 | Your card was declined   |
      | 4000000000000127 | 321 | 12 / 16 | Your card's security code is incorrect |
      | 4242424242424241 | 321 | 12 / 16 | Your card number is incorrect |
      | 4000000000000101 | 321 | 12 / 16 | Your card's security code is incorrect |

  @javascript @wip
  Scenario: Card is declined and alternative card entered
    When I go to the new account page
    And I enter my name and email address
    And I use a card that will be declined
    And I enter 4000000000000002, 321 and 10 / 20
    Then I should see "Your card was declined"
    And I use a card that is valid
    When I enter 4242424242424242, 321 and 10 / 20
    Then I should see "Thanks for subscribing."

