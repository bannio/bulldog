@defcustomer
Feature: I can set a default customer to use on bills
  In order to make it easier for data entry
  I want the new bill form to have a default customer
  and that customer should be selectable

  Background:
    Given I am a user with an account
    And I sign in with js
    And wait 1
    And I have the following data already saved
    # customer  | supplier | category |
    | Household | Asda     | Food     |
    | Business  | Tesco    | Clothes  |

  @javascript
  Scenario: Set a customer as default
    Given I visit the Customers page
    And I click the "Household" row
    And wait 1
    Then I should be on the Edit Customer page
    And I should see "set this as my default"
    When I check "customer_is_default" checkbox
    And I click button Save
    And wait 1
    Then customer "Household" is the default
    When I am on the bills page
    And I click on New
    Then I should see "Household"

