@landing
Feature: Landing Page
  In order to attract people to try the application
  there should be a landing page accessible to all

Background:
  Given I exist as a user
  And I am not logged in

Scenario: The application has a home page
  Given the application exists
  When I visit the home page
  Then I should be on the Home page

Scenario: There is an About page 
  When I visit the home page
  Then I should see a About Us link
  When I click the About Us link within the footer
  Then I should be on the About page

Scenario: The available links depend on if I am signed in or not
  When I visit the home page
  Then I should see a Sign in link
  And I should see a Sign up link
  And I should not see a Sign out link

Scenario: When signed in the links change
  When I sign in with valid credentials
  And I visit the home page
  Then I should not see a Sign in link
  And I should not see a Sign up link
  And I should see a Sign out link

