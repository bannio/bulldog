@landing
Feature: Landing Page
  In order to attract people to try the application
  there should be a landing page accessible to all

Scenario: The application has a home page
  Given the application exists
  When I visit the home page
  Then I should be on the Home page

Scenario: There is an About page 
  When I visit the home page
  Then I should see a About link
  When I click on About
  Then I should be on the About page