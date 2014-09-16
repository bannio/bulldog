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

  Scenario: I can only see my own customers
    Given There is another account with a customer
    And I have a customer
    When I visit the Customers page
    Then I should only see my customer

  Scenario: I cannot cheat by typing in the URL field
    Given There is another account with a customer
    And I have a customer
    And I type the other customers ID in the edit URL
    Then I should see "not found or not authorised"

  Scenario: Duplicate names are not allowed
    Given I have a customer "MyCustomer"
    When I create another "MyCustomer"
    Then I should see "A customer with that name already exists"
    
  Scenario: Delete a customer with no bills
    Given I have a customer "MyCustomer"
    When I edit the customer "MyCustomer"
    Then I should see a Delete button
    When I click on Delete
    Then I should be on the Customers page
    And I should see "MyCustomer destroyed"
