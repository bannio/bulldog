@customer
Feature: Manage Customer records
  In order to be able to group receipts (bills) by a customer
  and potentially invoice them, I need to be able to add
  customer details and edit them when necessary

  Background:
    Given I am a user with an account
    And I sign in

  Scenario: with no customer
    Given I have no customer
    And I visit the home page
    And I click on Customers
    Then I should be on the Customers page
    When I click on New Customer
    And I fill in customer details and click save
    Then I should see "Customer successfully created"
    And I should be on the Customers page
    And I should have a Customer record saved

  @javascript
  Scenario: edit an existing customer
    Given I have a customer
    And I visit the Customers page
    And I click the first table row
    Then I should be on the Edit Customer page
    And I fill in customer details and click save
    Then I should see "Customer successfully updated"
    And I should be on the Customers page