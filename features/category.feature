@category
Feature: In order to keep the categories fit for purpose
         I want to be able to rename or replace or delete them

  Background: To managing categories

    Given I am a user with an account
    And I sign in
    And I have the following bills
    # customer  | supplier | category | date       | description        | amount |
    | Household | Asda     | Food     | 10-12-2012 | Coffee             | 5.46   |
    | Household | Tesco    | Clothes  | 12-12-2012 | Tickets            | 46.00  |
    | Business  | Asda     | Mileage  | 10-12-2012 | business trip      | 100.00 |
    | Household | Asda     | Food     | 10-11-2012 | more coffee        | 5.00   |
    | Business  | Asda     | Food     | 10-11-2012 | coffee biscuits    | 5.00   |
    | Business  | Asda     | foods    | 10-11-2012 | coffee biscuits    | 5.00   |

  Scenario: There is a category menu item
    Given I visit the home page
    Then I should see "Categories"
    When I click on Categories
    Then I should be on the Categories page

  Scenario: Categories are listed in a table
    Given I visit the categories page
    Then I should see 4 categories
    And I should see "Clothes"
    And I should see "Food"
    And I should see "Mileage"
    And I should see "foods"

  @javascript
  Scenario: I can edit a category name
    Given I visit the categories page
    When I click the second table row
    Then I should be on the Edit Category page
    And I should see "Food" within the category_name field

  Scenario: I cannot create a duplicate name
    If I change a category name to an existing name it should
    reassign the bills to the new name category and delete the
    old name one rather than rename the old one and create a duplicate

    Given I visit the edit page for "foods"
    And I enter "Food" in the category_name field and click Save
    Then I should be on the Categories page
    And I should see "category foods deleted and bills assigned to Food"
    And I should see 3 categories
    When I am on the bills page
    Then I should see 4 bills with a category of "Food"

  Scenario: I can rename to a brand new name
    If the new name is not already used then the category
    is renamed so the total numnber of categories is
    unchanged. 
    
    Given I visit the edit page for "foods"
    And I enter "Vitals" in the category_name field and click Save
    Then I should be on the Categories page
    And I should see "category foods renamed to Vitals"
    And I should see 4 categories
    When I am on the bills page
    Then I should see 1 bills with a category of "Vitals"
