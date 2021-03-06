@bills
Feature: In order to track my costs
  I need to be able to input bills

  Background: To recording a bill.
    To keep things simple let's make the following assumptions
    apply to all the scenarios:

    Given I am a user with an account
    And I sign in with js
    And wait 1
    And I have the following data already saved
    # customer  | supplier | category |
    | Household | Asda     | Food     |
    | Business  | Tesco    | Clothes  |
    And I start with a total expenses balance of £0
    # And I am on the new bill screen


  @javascript @thisone
  Scenario: Enter a receipt for known supplier and customer
    Given I am on the new bill screen
    # And wait 1
    When I add a Household bill from Asda for £20
    And I click button Save
    And wait 1
    And I click for another new bill
    And I add a Business bill from Tesco for £5
    And I click button Save
    And wait 1
    Then the total expenses should be £25
    And the Household customer total should be £20
    And the Asda supplier total should be £20
    And the Tesco supplier total should be £5
    And the Business customer total should be £5

  @javascript
  Scenario: Try to save a bill with no amount
    When I am on the bills page
    And I click on New
    When I leave the amount empty
    And I click button Save
    Then I should see "can't be blank" in modal form
    And I should be on the "New Bill" modal

  Scenario: I can list bills
    Given I have the following bills
    # customer  | supplier | category | date       | description        | amount |
    | Household | Asda     | Food     | 10-12-2012 | Coffee             | 5.46   |
    | Household | Tesco    | Clothes  | 12-12-2012 | Tickets            | 46.00  |
    | Business  | Asda     | Mileage  | 10-12-2012 | business trip      | 100.00 |
    | Household | Asda     | Food     | 10-11-2012 | more coffee        | 5.00   |
    | Business  | Asda     | Food     | 10-11-2012 | coffee biscuits    | 5.00   |
    When I am on the bills page
    Then I should see "more coffee"
    And I should see "Coffee"
    And there is a link to add a new bill

  @javascript
  Scenario: I can edit a bill
    Given I have the following bills
    # customer  | supplier | category | date       | description        | amount |
    | Household | Asda     | Food     | 10-12-2012 | Coffee             | 5.46   |
    | Household | Tesco    | Clothes  | 12-12-2012 | Tickets            | 46.00  |
    | Business  | Asda     | Mileage  | 10-12-2012 | business trip      | 100.00 |
    | Household | Asda     | Food     | 10-11-2012 | more coffee        | 5.00   |
    | Business  | Asda     | Food     | 10-11-2012 | coffee biscuits    | 5.00   |
    And I am on the bills page
    And there is a link to add a new bill
    When I click the first table row
    # And wait 1
    Then I should be on the "Edit Bill" modal
    When I change the bill Description to "changed it here" and press save
    Then I should be on the Bills page
    And I should see "changed it here"

  Scenario: I cannot cheat and type in the URL of someone else's bill
    Given another user has a bill
    And I type in the other users bill ID in the /bills/ID/edit URL
    Then I should see "not found or not authorised"
    And we should be on the Home page

  Scenario: I can cancel an edit
    Given I have the following bills
    # customer  | supplier | category | date       | description        | amount |
    | Household | Asda     | Food     | 10-12-2012 | Coffee             | 5.46   |
    | Household | Tesco    | Clothes  | 12-12-2012 | Tickets            | 46.00  |
    And I am on the edit page for the first bill
    Then I should see "Coffee" in the "Description" field
    And I should see a Cancel button
    When I change the bill Description to "changed it here" and press Cancel
    Then I should be on the Bills page
    And I should not see "changed it here"
    And I should see "Coffee"

  Scenario: I can delete a bill if it hasn't been invoiced
    Note that only uninvoiced bills are visible in the index list
    Deleting by tamporing with the URL is tested in Rspec

    Given I have the following bills
    # customer  | supplier | category | date       | description        | amount |
    | Household | Asda     | Food     | 10-12-2012 | Coffee             | 5.46   |
    | Household | Tesco    | Clothes  | 12-12-2012 | Tickets            | 46.00  |
    And I am on the edit page for the first bill
    When I click button Delete
    Then I should see "Bill successfully deleted"
    And I should be on the Bills page
    And I should not see "Coffee"

  Scenario: I can sort bills by date, supplier, category etc.
    Default sort order is by date with youngest at the top.
    Note that the sort order is case sensitive so capitals may come first.
    Given I have the following bills
    # customer  | supplier | category | date       | description        | amount |
    | Household | Asda     | Food     | 11-12-2012 | Coffee             | 5.46   |
    | Household | Tesco    | Clothes  | 12-12-2012 | Tickets            | 46.00  |
    | Business  | BigCo    | Mileage  | 10-12-2012 | business trip      | 100.00 |
    | Household | Asda     | Food     | 14-11-2012 | more coffee        | 4.00   |
    | Business  | Asda     | Food     | 13-11-2012 | coffee biscuits    | 5.00   |
    And I am on the bills page
    Then row 1 should include "Tickets"
    And row 2 should include "Coffee"
    When I click on Date
    Then row 1 should include "coffee biscuits"
    And row 2 should include "more coffee"
    When I click on Category
    Then row 1 should include "Tickets"
    And row 5 should include "business trip"
    When I click on Description
    Then row 1 should include "Coffee"
    And row 5 should include "more coffee"
    When I click on Amount
    Then row 1 should include "more coffee"
    And row 5 should include "business trip"
    When I click on Supplier
    Then row 1 should include "Asda"
    And row 4 should include "BigCo"
    When I click on Customer
    Then row 1 should include "Business"
    And row 3 should include "Household"

