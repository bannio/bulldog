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
    And I click on Invoice Setup
    Then I should be on the Invoice Setup page
    And I should see "Your details"