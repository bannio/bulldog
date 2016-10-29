@supplier
Feature: manage supplier names
  In order to be able to correct spellings of suppliers and merge them
  if I have entered two different spellings for the same supplier, I
  need to be able to edit the list of suppliers

  Background:
    Given I am a user with an account
    And I sign in with js
    And wait 1
    And I have the following bills
    # customer  | supplier | category | date       | description        | amount |
    | Household | Asda     | Food     | 10-12-2012 | Coffee             | 5.46   |
    | Household | Tesco    | Clothes  | 12-12-2012 | Tickets            | 46.00  |
    | Business  | Asda     | Mileage  | 10-12-2012 | business trip      | 100.00 |
    | Household | Asda     | Food     | 10-11-2012 | more coffee        | 5.00   |
    | Business  | Asdar    | Food     | 10-11-2012 | coffee biscuits    | 5.00   |
    | Business  | Asda     | foods    | 10-11-2012 | coffee biscuits    | 5.00   |

  Scenario: There is a supplier menu item
    Given I visit the home page
    Then I should see "Suppliers"
    When I click on Suppliers
    Then I should be on the Suppliers page
    And I should see "Tesco"
    And I should see "Asda"

  @javascript
  Scenario: Editing a supplier name
    Given I am on the bills page
    Then I should see 1 bills with a supplier of "Tesco"
    And I should see 4 bills with a supplier of "Asda"
    And I should see 1 bills with a supplier of "Asdar"
    Given I visit the suppliers page
    When I click the second table row
    And wait 1
    Then I should be on the Edit Supplier page
    And I should see "Asdar" within the supplier_name field
    When I enter "Asda" in the supplier_name field and click Save
    And wait 1
    Then I should be on the Suppliers page
    And I should see "supplier Asdar deleted and bills assigned to Asda"
    When I click the second table row
    And wait 1
    Then I should be on the Edit Supplier page
    And I should see "Tesco" within the supplier_name field
    When I enter "Tesco Ltd" in the supplier_name field and click Save
    And wait 1
    Then I should be on the Suppliers page
    And I should see "supplier Tesco renamed to Tesco Ltd"
    When I am on the bills page
    Then I should see 1 bills with a supplier of "Tesco Ltd"
    And I should see 5 bills with a supplier of "Asda"



