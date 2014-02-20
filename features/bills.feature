@bills
Feature: In order to track my costs
  I need to be able to input bills

  Background: To recording a bill. 
    To keep things simple let's make the following assumptions
    apply to all the scenarios:
    
    Given I am a user with an account
    And I sign in
    And I have the following data already saved
    # customer  | supplier | category |
    | Household | Asda     | Food     |
    | Business  | Tesco    | Clothes  |
    And I start with a total expenses balance of £0
    And I am on the new bill screen


  @javascript 
  Scenario: Enter a receipt for known supplier and customer
    When I add a Household bill from Asda for £20
    And I am on the new bill screen
    And I add a Business bill from Tesco for £5
    Then the total expenses should be £25
    And the Household customer total should be £20
    And the Asda supplier total should be £20
    And the Tesco supplier total should be £5
    And the Business customer total should be £5

  @javascript
  Scenario: Try to save a bill with no amount
    When I leave the amount empty
    Then I should see "can't be blank"
    And I should be on the New Bill page

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
    Then I should be on the Edit Bill page
    When I change the bill description to "changed it here" and press save
    Then I should be on the Bills page
    And I should see "changed it here"

  Scenario: I cannot cheat and type in the URL of someone else's bill
    Given another user has a bill
    And I type in the other users bill ID in the /bills/ID/edit URL
    Then I should see "not found or not authorised"
    And I should be on the Home page

  Scenario: I can cancel an edit
    Given I have the following bills
    # customer  | supplier | category | date       | description        | amount |
    | Household | Asda     | Food     | 10-12-2012 | Coffee             | 5.46   |
    | Household | Tesco    | Clothes  | 12-12-2012 | Tickets            | 46.00  |
    And I am on the edit page for the first bill
    Then I should see "Coffee" in the "description" field
    And I should see a Cancel button
    When I change the bill description to "changed it here" and press Cancel
    Then I should be on the Bills page
    And I should not see "changed it here"
    And I should see "Coffee"

  @undertest
  Scenario: I can delete a bill if it hasn't been invoiced
    Note that only uninvoiced bills are visible in the index list
    Deleting by tamporing with the URL is tested in Rspec
    
    Given I have the following bills
    # customer  | supplier | category | date       | description        | amount |
    | Household | Asda     | Food     | 10-12-2012 | Coffee             | 5.46   |
    | Household | Tesco    | Clothes  | 12-12-2012 | Tickets            | 46.00  |
    And I am on the edit page for the first bill
    Then I should see "Destroy"
    When I click on Destroy
    Then I should see "Bill successfully deleted"
    And I should be on the Bills page
    And I should not see "Coffee"







