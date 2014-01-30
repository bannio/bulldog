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
    
  Scenario: Enter a receipt for known supplier and customer
    When I add a Household bill from Asda for £20
    And I am on the new bill screen
    And I add a Business bill from Tesco for £5
    Then the total expenses should be £25
    And the Household customer total should be £20
    And the Asda supplier total should be £20
    And the Tesco supplier total should be £5
    And the Business customer total should be £5

  Scenario: Try to save a bill with no amount
    When I leave the amount empty
    Then I should see "can't be blank"
    And I should be on the New Bill page