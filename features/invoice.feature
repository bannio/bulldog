@invoice
Feature: Invoices
  In order to keep the current bills count to a reasonable number
  and to allow for recharging clients or employers for expenses
  I need to be able to create an invoice based on customer and date

  Background:
    Given I am a user with an account
    And I sign in 
    And I have the following bills
    # customer  | supplier | category | date       | description        | amount |
    | Household | Asda     | Food     | 10-12-2012 | Coffee             | 5.46   |
    | Household | Tesco    | Clothes  | 12-12-2012 | Tickets            | 46.00  |
    | Business  | Asda     | Mileage  | 10-12-2012 | business trip      | 100.00 |
    | Household | Asda     | Food     | 10-11-2012 | more coffee        | 5.00   |
    | Business  | Asda     | Food     | 10-11-2012 | coffee biscuits    | 5.00   | 

  Scenario: Create an invoice
    As an invoice gathers all uninvoiced bills for the selected customer
    and the bills index page only shows uninvoiced bills, after creating
    an invoice for Business, Business bills should disappear from the 
    bills index.

    Given I am on the bills page
    Then I should see "Business"
    And I should see "Household"
    Given I am on the New Invoice page
    And I select the customer Business
    And I click button Create Invoice
    Then I should be on the Show Invoice page
    And I should see "Invoice 1"
    And I should see "Total £105.00"
    When I am on the bills page
    Then I should not see "Business"
    And I should see "Household"

  Scenario: list invoices
    There should be an index list of invoices, [sortable by customer, date]

    Given I visit the home page
    And I click on Invoices
    Then I should be on the Invoices page
    And I should see a New button 

  @javascript
  Scenario: Edit an invoice
    I can edit everything except the customer. If the customer were to change,
    all the bills would be removed in any case. 

    Given I have created the Business invoice
    And I am on the invoices index page
    When I click the first table row
    Then I should be on the Show Invoice page
    When I click on Edit
    Then I should be on the Edit Invoice page
    When I change the comment to "changed comment"
    And I change the date to "2014-01-01"
    And I click button Update Invoice
    Then I should be on the Show Invoice page
    And I should see "changed comment"

  Scenario: Remove selected bills from invoice
    Given I have created the Business invoice
    And I am on the edit page for this invoice
    Then I should see 2 bills
    When I check one bill and click Update Invoice
    Then I should see 1 bill 

  Scenario: Delete an invoice
    Given I have created the Business invoice
    When I am on the bills page
    Then I should not see "business trip"
    When I am on the invoices index page
    Then I should see "My business invoice"
    When I am on the edit page for this invoice
    Then I should see "Destroy"
    When I click on Destroy
    Then I should be on the Invoices page
    And I should not see "My business invoice"
    When I am on the bills page
    Then I should see "business trip"





