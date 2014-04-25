@invoice
Feature: Invoices
  In order to keep the current bills count to a reasonable number
  and to allow for recharging clients or employers for expenses
  I need to be able to create an invoice based on customer and date

  Background:
    Given I am not logged in
    Given I am a user with an account
    And I sign in 
    And I have an active "Standard" rate at 20%
    And I have an active "Zero" rate at 0%
    And I have the following bills
    # customer  | supplier | category | date       | description        | amount | vat_rate | vat |
    | Household | Asda     | Food     | 10-12-2012 | Coffee             | 5.46   |          |     |
    | Household | Tesco    | Clothes  | 12-12-2012 | Tickets            | 46.00  |          |     |
    | Business  | Asda     | Mileage  | 10-12-2012 | business trip      | 120.00 | Standard | 20  |
    | Household | Asda     | Food     | 10-11-2012 | more coffee        | 5.00   | Zero     |  0  |
    | Business  | Asda     | Food     | 10-11-2012 | more coffee        | 5.00   | Zero     |  0  |
    | Business  | Asda     | Food     | 10-11-2012 | coffee biscuits    | 5.00   | Standard |  1  |

  @javascript
  Scenario: Create an invoice
    As an invoice gathers all uninvoiced bills for the selected customer
    and the bills index page only shows uninvoiced bills, after creating
    an invoice for Business, Business bills should disappear from the 
    bills index.

    Given I am on the bills page
    Then I should see "Business"
    And I should see "Household"
    Given I am on the New Invoice page
    And I select "Business" as the invoice customer
    And I click button Create Invoice
    Then I should be on the Edit Invoice page
    And I should not see "Back"
    And I should see "Invoice 1"
    And I should see "Total £130.00"
    When I am on the bills page
    Then I should not see "Business"
    And I should see "Household"

  Scenario: list invoices
    There should be an index list of invoices, sortable by customer, date etc.
    The default order is youngest number first.

    Given I have the following invoices
    # no | customer | comment     | date       | total  |
    | 1  | Household | A invoice   | 2012-12-10 | 5.46   |
    | 2  | Business  | B invoice   | 2012-12-12 | 46.00  |
    | 3  | Business  | C invoice B | 2012-10-12 | 100.00 |
    | 4  | Household | D invoice   | 2012-10-11 | 4.00   |
    | 5  | Business  | E invoice   | 2012-10-10 | 5.00   | 
    | 10 | Business  | F invoice   | 2012-10-11 | 5.00   | 

    Given I visit the home page
    And I click on Invoices
    Then I should be on the Invoices page
    And I should see 6 invoices
    And I should see a New button
    And There is a search field for comment
    When I type "B" in the search field and press enter
    Then I should see 2 invoices
    When I type "" in the search field and press enter
    Then I should see 6 invoices
    When I click on No.
    Then row 1 should include "A invoice"
    And row 6 should include "F invoice"
    When I click on Comment
    Then row 1 should include "A invoice"
    And row 6 should include "F invoice"
    When I click on Date
    Then row 1 should include "E invoice"
    And row 6 should include "B invoice"
    When I click on Amount
    Then row 1 should include "D invoice"
    And row 6 should include "C invoice"

  @javascript
  Scenario: Edit an invoice
    I can edit everything except the customer. If the customer were to change,
    all the bills would be removed in any case. 

    Given I have the Business invoice
    And I am on the invoices index page
    When I click the first table row
    Then I should be on the Show Invoice page
    When I click on Edit
    And I wait
    Then I should be on the Edit Invoice page
    And I should see "Cancel"
    When I change the comment to "changed comment"
    And I change the date to "2014-01-01"
    And I click button Save Changes
    Then I should be on the Invoices page
    And I should see "changed comment"

  @javascript
  Scenario: Remove selected bills from invoice
    Given I have the Business invoice
    And I am on the edit page for this invoice
    Then I should see 3 bills
    When I check one bill and click Save Changes
    Then I should be on the Invoices page
    When I click the first table row
    Then I should be on the Show Invoice page 
    Then I should see 2 bill 

  @javascript
  Scenario: Delete an invoice
    Given I have the Business invoice
    When I am on the bills page
    Then I should not see "business trip"
    When I am on the invoices index page
    Then I should see "My business invoice"
    When I am on the edit page for this invoice
    Then I should see "Delete"
    When I click the Delete button and confirm OK
    Then I should be on the Invoices page
    And I should not see "My business invoice"
    When I am on the bills page
    Then I should see "business trip"

  Scenario: Button labels change in edit depending on origin
    Given I have the Business invoice
    And I am on the edit page for this invoice
    Then I should see 3 bills
    And I should see "Cancel"

  Scenario: VAT columns and totals
    Given VAT is enabled
    And I have the Business invoice
    And I am on the edit page for this invoice
    Then I should see "VAT"
    And I should see "Standard £20.00"
    And I should see "Total £130.00 £21.00"
    And I am on the show page for this invoice
    And I should see "VAT Summary"
    And I should see "Standard £21.00"
    And I should see "Zero £0.00"

  @javascript @ut
  Scenario: Set a print header
    Given I have the Business invoice
    And I am on the edit page for this invoice
    When I fill in header with "Test Header"
    And I click button Save Changes
    Then I should be on the Invoices page
    When I click the first table row
    Then I should be on the Show Invoice page
    And I should see "Test Header"


