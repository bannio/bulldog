@tools
Feature: The tools menu provides access to a number of set up 
  and management utilities

  Background:
    Given I am a user with an account
    And I have a settings entry
    And I sign in

  Scenario: Document Settings
    Given I visit the home page
    And I click on Tools
    And I click on Document Setup
    Then I should be on the Document Setup page
    And I should see "Your Address Details"

  Scenario: VAT registration number on settings page
    Given VAT is enabled
    And I visit the settings page
    Then I should see "VAT Registration Number"
    When I click on Edit
    And I enter "12345678" in the setting_vat_reg_no field
    And I click button Save
    Then I should be on the Document Setup page
    And I should see "12345678"

  Scenario: No VAT fields when VAT not enabled
    Given I visit the settings page
    Then I should not see "Your VAT Details"
    And I should not see "VAT Registration Number"
    When I click on Edit
    Then I should not see "Your VAT Details"

  Scenario: Set printing preferences
    Given VAT is enabled
    And I visit the settings page
    Then I should see "Printing Preferences (set defaults)"
    And I should see "Include VAT?"
    And I should see "Include Bank Details?"
    When I click on Edit
    And I should see "Include VAT?"
    And I should see "Include Bank Details?"

  Scenario: telephone and email
    Given I visit the settings page
    Then I should see "Telephone No."
    And I should see "Email address"
    When I click on Edit
    And I enter "0101010101" in the setting_telephone field
    And I enter "test@example.com" in the setting_email field
    And I click button Save
    Then I should be on the Document Setup page
    And I should see "0101010101"
    And I should see "test@example.com"

  Scenario: Upload logo file
    # lots of setup because of the before_update callback on account.save
    Given a Base Plan exists
    And a Business Monthly Plan exists
    And a Business Annual Plan exists
    And stripe-ruby-mock is running
    And the account has a valid Stripe Customer token
    And the account is subscribed to a business plan
    And I visit the settings page
    Then I should see "Logo"
    When I click on Edit
    And I attach a logo file
    And I click button Save
    Then I should be on the Document Setup page
    And the logo thumbnail is displayed
