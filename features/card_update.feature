@card_update
Feature: Card update
  In the event that a subscriber's stored card is invalid or they just want to
  use a different one, they should have the option to change it.

  Background:
    Given I am logged in
    And a Base Plan exists
    # And no emails have been sent
    # And stripe-ruby-mock is running
    # And the account has a valid Stripe Customer token

  # @javascript
  Scenario: Visit manage subscription
    When I visit the Manage Subscription page
    Then I should see "Update card"
    When I click on Update card
    Then I should see "New Card Details"
    And I should see button "Update Card"
    And I should see "Cancel"
    # Stopping the test here as it otherwise sends to Stripe.
    # The correct presentation of a card details view is tested.
    # Uncomment the next two lines to run against Stripe.

    # When I enter new card expiry "12 / 20"
    # Then I should see "There was a problem with your payment card"

    # because test Stripe returns a token that stripe-ruby-mock doesn't recognise
