@vat
Feature: VAT
  So that VAT registered users can record VAT on bills and invoices
  we need a VAT table and a maintenance interface

Background:
  Given I am a user with an account
  And a Base Plan exists
  And a Business Monthly Plan exists
  And a Business Annual Plan exists
  And the account is subscribed to a business plan
  And I sign in with js
  And wait 1

@javascript
Scenario: Add VAT rates
  When I visit the VAT page
  Then I should see "Name Rate (%) Active"
  When I click on New
  And I fill in name with "Standard"
  And I fill in rate with "20"
  And I check active
  And I click button Save
  Then I should be on the VAT page
  And I should see "VAT rate successfully added"

@javascript
Scenario: change the name of an active rate and deactivate it
  Given I have an active "Standard" rate at 20%
  When I visit the VAT page
  Then row 1 should include "Standard"
  When I click the first table row
  Then I should be on the "Edit VAT Rate" modal
  When I fill in name with "Old Standard"
  And I uncheck "active" and click Save
  And wait 1
  Then I should be on the VAT page
  And the "Old Standard" rate should be inactive

@javascript
Scenario: Cannot duplicate name of an active rate
  Given I have an active "Standard" rate at 20%
  And I visit the VAT page
  When I click on New
  And I fill in name with "Standard"
  And I fill in rate with "20"
  And I check active
  And I click button Save
  Then I should see "There is already an active rate with this name"

@javascript
Scenario: I can duplicate name of an inactive rate
  Given I have an inactive "Standard" rate at 20%
  And I visit the VAT page
  When I click on New
  And I fill in name with "Standard"
  And I fill in rate with "20"
  And I check active
  And I click button Save
  Then I should see "VAT rate successfully added"

@javascript
Scenario: I cannot change the % rate if it has been used
  Given I have an active "Standard" rate at 20%
  And I have a bill using the "Standard" rate
  When I visit the VAT page
  And I click the first table row
  Then I should be on the "Edit VAT Rate" modal
  When I fill in rate with "10"
  And I click button Save
  Then I should see "% rate already in use on bills"

@javascript
Scenario: I can change the % rate if it has not been used
  Given I have an active "Standard" rate at 20%
  When I visit the VAT page
  And I click the first table row
  Then I should be on the "Edit VAT Rate" modal
  When I fill in rate with "10"
  And I click button Save
  Then I should see "VAT rate successfully updated"

@javascript
Scenario: list only active rates, button to show all
  Given I have an active "Standard" rate at 20%
  And I have an active "Reduced" rate at 5%
  And I have an inactive "Old rate" rate at 20%
  When I visit the VAT page
  Then I should see 2 rates
  When I click on Show All
  And wait 1
  Then I should see 3 rates

@javascript
Scenario: delete a VAT rate
  This should not be allowed if there are bills using the rate
  Given I have an active "Standard" rate at 20%
  And I have an active "Reduced" rate at 5%
  And I have a bill using the "Standard" rate
  When I visit the VAT page
  And I click the first table row
  Then I should be on the "Edit VAT Rate" modal
  When I click Delete and confirm
  Then I should see "VAT rate successfully deleted"
  Then I click the first table row
  Then I should be on the "Edit VAT Rate" modal
  When I click Delete and confirm
  Then I should see "This rate is in use and cannot be deleted"

# @javascript
# Scenario: select to enable VAT
#   When I visit the Account page
#   And I click on Change Plan
#   And I check Enable VAT on bills?
#   And I click button Save
#   Then I visit the Bills page
#   And I click on New
#   Then I should see "VAT rate"
#   And I should see placeholder "VAT amount"
#   Then I visit the Account page
#   And I click on Change Plan
#   And I uncheck Enable VAT on bills?
#   And I click button Save
#   Then I visit the Bills page
#   And I click on New
#   Then I should not see "VAT rate"
#   And I should not see placeholder "VAT amount"

@javascript
Scenario: VAT select field limits choice to defined active entries
  The way the system and this test works, the previous valid entry is retained
  if an invalid entry is typed in and you press 'tab' to leave the field
  Given I have an active "Standard" rate at 20%
  And I have an active "Reduced" rate at 5%
  And I have an inactive "Old" rate at 15%
  And VAT is enabled
  When I visit the Bills page
  And I click on New
  Then I should see "VAT rate" in modal form
  And I type "Standard" in the vat_rate select field
  Then I should see "Standard"
  And I should not see "VAT rate" in modal form
  When I type "missing" in the vat_rate select field
  Then I should not see "missing"
  And I should see "Standard"
  When I type "Old" in the vat_rate select field
  Then I should not see "Old"
  And I should see "Standard"

Scenario: The bills index table lists VAT when VAT is enabled in the account
  Given I have an active "Standard" rate at 20%
  Given I have an active "Zero" rate at 0%
  And VAT is enabled
  And I have the following bills
    # customer  | supplier | category | date       | description        | amount | vat_rate | vat |
    | Household | Asda     | Food     | 16-12-2012 | Coffee             | 5.46   |          |     |
    | Household | Tesco    | Clothes  | 15-12-2012 | Tickets            | 46.00  | Zero     | 0   |
    | Business  | Asda     | Mileage  | 14-12-2012 | business trip      | 120.00 | Standard | 20  |
    | Household | Asda     | Food     | 13-12-2012 | more coffee        | 5.00   |          |     |
    | Business  | Asda     | Food     | 12-12-2012 | coffee biscuits    | 5.00   | Zero     | 0   |
    When I am on the bills page
    Then row 3 should include "Standard £20.00"
    And row 5 should include "Zero £0.00"

