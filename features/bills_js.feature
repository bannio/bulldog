@bills_js
Feature: Create customers, suppliers and categories on the fly
  In order to make the system really simple to use
  I don't need to go elsewhere to create a bill for a new
  customer, supplier or category

  Background:
    Given I am a user with an account
    And I sign in with js
    And wait 1

  @javascript
  Scenario: My first bill
    There are no existing customers, suppliers or categories

    Given I am on the bills page
    And I click on New
    Then I should be on the "New Bill" modal
    When I type "a new customer" in the customer select field
    And I type "a new supplier" in the supplier select field
    And I type "a new category" in the category select field
    And I enter "My new bill" in the Description field
    And I enter "10" in the Amount field
    And I click button Save
    Then I should be on the Bills page
    And I should see "My new bill"

  @javascript
  Scenario: An empty new supplier does not save
    Given I am on the bills page
    And I click on New
    Then I should be on the "New Bill" modal
    When I type "a new customer" in the customer select field
    And I type "" in the supplier select field
    And I type "a new category" in the category select field
    And I enter "My new bill" in the Description field
    And I enter "10" in the Amount field
    And I click button Save
    Then I should see "can't be blank"

  @javascript
  Scenario: An numeric new supplier does not save a name
    Given I am on the bills page
    And I click on New
    Then I should be on the "New Bill" modal
    When I type "a new customer" in the customer select field
    And I type "10" in the supplier select field
    And I type "a new category" in the category select field
    And I enter "My new bill" in the Description field
    And I enter "10" in the Amount field
    And I click button Save
    Then I should see "Missing - please edit"