@stripe_sign_up
Feature: Sign up
  In order to get access to protected sections of the site
  As a user
  I want to be able to sign up

  Background:
    Given I am not logged in
    And a Base Plan exists
    And no emails have been sent

  @javascript
  Scenario: User signs up with valid data
    When I visit the home page
    When I click on Sign up
    Then we should be on the Plans page
    When I Sign up for Base Plan
    Then we should be on the New Account page
    When I enter my name and email address
    And my credit card details
    And I click button Subscribe
    Then I should see "Thanks for subscribing."
    # And wait 5
    Then I should receive an email
    When I open the email
    Then I should see "confirm" in the email body
    When I follow "confirm" in the email
    Then I should be on the Account Activation page
    When I enter account activation details 
    Then I should see "Your account was successfully confirmed."
    And I should be on the Welcome page
    And I have an Account record saved
    
  
  Scenario: User signs up with invalid email
    When I sign up with an invalid email
    Then I should see an invalid email message

  Scenario: User signs up without a name
    When I sign up with an invalid email
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

  @javascript
  Scenario Outline: User enters an invalid credit card number
    Note that the dates and years will go out of date. Need to find a better way.
    The form prevents years in the past.
    When I go to the new account page
    And I enter my name and email address
    And I enter <card_no>, <cvc>, <month> and <year>
    Then I should get <result>

    Examples: 
      | card_no          | cvc | month    | year | result       |
      | 4242424242424242 | 123 | January  | 2014 | Your card's expiration month is invalid |
      | 4242424242424242 | 1   | December | 2014 | Your card's security code is invalid   |
      | 4242424242424242 |     | December | 2014 | Your card's security code is invalid   |
      | 4000000000000002 | 123 | December | 2014 | Your card was declined   |
      | 4000000000000127 | 321 | December | 2014 | Your card's security code is incorrect |
      | 4242424242424241 | 321 | December | 2014 | Your card number is incorrect |
      | 4000000000000101 | 321 | December | 2014 | Your card's security code is incorrect |

  @javascript
  Scenario: Card is declined and alternative card entered
    When I go to the new account page
    And I enter my name and email address
    And I enter 4000000000000002, 321, October and 2020
    Then I should see "Your card was declined"
    When I enter 4242424242424242, 321, October and 2020
    Then I should see "Thanks for subscribing."

