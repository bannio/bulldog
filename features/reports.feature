@reports
Feature: Analysis menu
  In order to view graphs and maybe extract data from tables
  I need to have a menu option and views for reports

Background:
    Given I am a user with an account
    And I sign in 
    And I have the following bills
    # customer  | supplier | category | date       | description        | amount |
    | Household | Asda     | Food     | 2012-10-12 | Coffee             | 5.46   |
    | Household | Tesco    | Clothes  | 2012-10-13 | Tickets            | 46.00  |
    | Business  | Asda     | Mileage  | 2013-01-25 | business trip      | 100.00 |
    | Household | Asda     | Clothes  | 2013-02-01 | from George        | 5.00   |
    | Business  | Asda     | Food     | 2013-03-01 | coffee biscuits    | 5.00   | 

Scenario: Analysis Menu exists
  
  Given I visit the home page
  And I click on Analysis
  Then I should be on the Reports page
  And I should find 5 bills


Scenario: I can filter by date ranges
  Given I visit the Analysis page
  And I select "2013-01-01" as start date
  And I click button Submit
  Then I should find 3 bills
  When I select "2013-02-25" as end date
  And I click button Submit
  Then I should find 2 bills

Scenario: I can filter by customer, supplier and category
  Given I visit the Analysis page
  And I select "Household" as customer
  And I click button Submit
  Then I should find 3 bills
  When I select "Asda" as supplier
  And I click button Submit
  Then I should find 2 bills
  When I select "Clothes" from category
  And I click button Submit
  Then I should find 1 bills
  
@javascript
Scenario: Pagination keeps the selection criteria
  (note assumed pagination of 25)
  Given I have the following bills
  # customer  | supplier | category | date       | description        | amount |
  | Household | Asda     | Food     | 2012-10-12 | Coffee             | 5.46   |
  | Household | Tesco    | Clothes  | 2012-10-13 | Tickets            | 46.00  |
  | Business  | Asda     | Mileage  | 2013-01-25 | business trip      | 100.00 |
  | Household | Asda     | Clothes  | 2013-02-01 | from George        | 5.00   |
  | Business  | Asda     | Food     | 2013-03-01 | coffee biscuits    | 5.00   | 
  | Household | Asda     | Food     | 2012-10-12 | Coffee             | 5.46   |
  | Household | Tesco    | Clothes  | 2012-10-13 | Tickets            | 46.00  |
  | Business  | Asda     | Mileage  | 2013-01-25 | business trip      | 100.00 |
  | Household | Asda     | Clothes  | 2013-02-01 | from George        | 5.00   |
  | Business  | Asda     | Food     | 2013-03-01 | coffee biscuits    | 5.00   |
  | Household | Asda     | Food     | 2012-10-12 | Coffee             | 5.46   |
  | Household | Tesco    | Clothes  | 2012-10-13 | Tickets            | 46.00  |
  | Business  | Asda     | Mileage  | 2013-01-25 | business trip      | 100.00 |
  | Household | Asda     | Clothes  | 2013-02-01 | from George        | 5.00   |
  | Business  | Asda     | Food     | 2013-03-01 | coffee biscuits    | 5.00   |
  | Household | Asda     | Food     | 2012-10-12 | Coffee             | 5.46   |
  | Household | Tesco    | Clothes  | 2012-10-13 | Tickets            | 46.00  |
  | Business  | Asda     | Mileage  | 2013-01-25 | business trip      | 100.00 |
  | Household | Asda     | Clothes  | 2013-02-01 | from George        | 5.00   |
  | Business  | Asda     | Food     | 2013-03-01 | coffee biscuits    | 5.00   |
  | Household | Asda     | Food     | 2012-10-12 | Coffee             | 5.46   |
  | Household | Tesco    | Clothes  | 2012-10-13 | Tickets            | 46.00  |
  | Business  | Asda     | Mileage  | 2013-01-25 | business trip      | 100.00 |
  | Household | Asda     | Clothes  | 2013-02-01 | from George        | 5.00   |
  | Business  | Asda     | Food     | 2013-03-01 | coffee biscuits    | 5.00   |
  | Household | Asda     | Food     | 2012-10-12 | Coffee             | 5.46   |
  | Household | Tesco    | Clothes  | 2012-10-13 | Tickets            | 46.00  |
  | Business  | Asda     | Mileage  | 2013-01-25 | business trip      | 100.00 |
  | Household | Asda     | Clothes  | 2013-02-01 | from George        | 5.00   |
  | Business  | Asda     | Food     | 2013-03-01 | coffee biscuits    | 5.00   |
  | Household | Asda     | Food     | 2012-10-12 | Coffee             | 5.46   |
  | Household | Tesco    | Clothes  | 2012-10-13 | Tickets            | 46.00  |
  | Business  | Asda     | Mileage  | 2013-01-25 | business trip      | 100.00 |
  | Household | Asda     | Clothes  | 2013-02-01 | from George        | 5.00   |
  | Business  | Asda     | Food     | 2013-03-01 | coffee biscuits    | 5.00   |
  | Household | Asda     | Food     | 2012-10-12 | Coffee             | 5.46   |
  | Household | Tesco    | Clothes  | 2012-10-13 | Tickets            | 46.00  |
  | Business  | Asda     | Mileage  | 2013-01-25 | business trip      | 100.00 |
  | Household | Asda     | Clothes  | 2013-02-01 | from George        | 5.00   |
  | Business  | Asda     | Food     | 2013-03-01 | coffee biscuits    | 5.00   |

  And I visit the Analysis page
  Then I should see "Filter bills"
  Then I should find 25 bills
  When I click on Table
  And I click for the next page
  And I click on Table
  Then I should find 20 bills
  When I select "Household" as customer
  And I click button View
  And I click on Table
  Then I should not see "Business" in the table
  When I click for the next page
  Then I should not see "Business" in the table
  And I should find 2 bills
  When I select "Business" as customer
  And I click button View
  And I click on Table
  Then I should see "Business" in the table
  And I should find 18 bills
