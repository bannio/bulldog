@vat
Feature: VAT
  So that VAT registered users can record VAT on bills and invoices
  we need a VAT table and a maintenance interface

Background:
  Given I am a user with an account
  And I sign in

@javascript
Scenario: Add VAT rates
  When I visit the VAT page
  Then I should see "Name Rate Active"
  When I click on New
  And I fill in name with "Standard"
  And I fill in rate with "20"
  And I check active 
  And I click button Save
  Then I should be on the VAT page
  And I should see "VAT rate successfully added"

@javascript
Scenario: edit VAT rate
  The rate column should not be editable if there are bills
  Given I have an active "Standard" rate at 20%
  When I visit the VAT page
  Then row 1 should include "Standard"
  When I click the first table row
  Then I should be on the "Edit VAT Rate" modal
  When I fill in name with "Old Standard"
  And I uncheck "active" and click Save
  Then I should be on the VAT page
  And the "Old Standard" rate should be inactive

@javascript @ut
Scenario: list only active rates, button to show all
  Given I have an active "Standard" rate at 20%
  And I have an active "Reduced" rate at 5%
  And I have an inactive "Old rate" rate at 20%
  When I visit the VAT page
  Then I should see 2 rates
  When I click on Show All
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
  


@javascript
Scenario: select to enable VAT
  When I visit the Account page
  And I click on Edit
  And I check Enable VAT on bills?
  And I click button Save
  Then I visit the Bills page
  And I click on New
  Then I should see "VAT rate"
  And I should see placeholder "VAT amount"
  Then I visit the Account page
  And I click on Edit
  And I uncheck Enable VAT on bills?
  And I click button Save
  Then I visit the Bills page
  And I click on New
  Then I should not see "VAT rate"
  And I should not see placeholder "VAT amount" 

@javascript
Scenario: VAT select field limits choice to defined entries
  Given I have an active "Standard" rate at 20%
  And I have an active "Reduced" rate at 5%
  And VAT is enabled
  When I visit the Bills page
  And I click on New
  Then I should see "VAT rate"
  And I type "Standard" in the vat_rate select field
  Then I should see "Standard"
  And I should not see "VAT rate"
  When I type "missing" in the vat_rate select field
  Then I should not see "missing"
  And I should see "Standard"

