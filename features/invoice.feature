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
    There should be an index list of invoices, sortable by customer, date etc.
    The default order is youngest number first.

    Given I have the following invoices
    # no | customer | comment     | date       | total  |
    | 1 | Household | A invoice   | 10-12-2012 | 5.46   |
    | 2 | Business  | B invoice   | 12-12-2012 | 46.00  |
    | 3 | Business  | C invoice B | 10-12-2012 | 100.00 |
    | 4 | Household | D invoice   | 10-11-2012 | 4.00   |
    | 5 | Business  | E invoice   | 10-11-2012 | 5.00   | 

    Given I visit the home page
    And I click on Invoices
    Then I should be on the Invoices page
    And I should see 5 invoices
    And I should see a New button
    And There is a search field for comment
    When I type "B" in the search field and press enter
    Then I should see 2 invoices
    When I type "" in the search field and press enter
    Then I should see 5 invoices
    When I click on No.
    Then row 1 should include "A invoice"
    And row 5 should include "E invoice"
    When I click on Comment
    Then row 1 should include "A invoice"
    And row 5 should include "E invoice"
    When I click on Date
    Then row 1 should include "E invoice"
    And row 5 should include "B invoice"
    When I click on Amount
    Then row 1 should include "D invoice"
    And row 5 should include "C invoice"

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





