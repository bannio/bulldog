@account
Feature: Account
  To facilitate future subscription plans and to store information
  for VAT enabled etc. An account should be created after first
  sign in (following confirmation) and this should be editable.

  Background:
    Given I am not logged in

  Scenario: Sign in first time
    Given I have no account
    And I sign up with just my email
    When I activate with a valid password
    Then I should be on the Welcome page
    And I should see "Your account was successfully confirmed."
    And I have an Account record saved

  Scenario: Sign in a second time
    Given I am a user with an account
    When I sign in
    Then I should be on the Welcome page

  Scenario: I can change my password
    Given I am a user with an account
    And  I sign in
    When I visit the home page
    And I click on Account
    And I click on Change Password
    Then I should be on the Change Password page

  Scenario: I can change my email address
    Given I am a user with an account
    And  I sign in
    When I visit the home page
    And I click on Account
    And I click on Change Email Address
    Then I should be on the Change Email Address page
    When I enter "changed@example.com" in the user_email field
    And I enter "changeme" in the user_current_password field
    And I click button Update
    Then I should see "You updated your account successfully, but"
    And I should see "we need to verify your new email address."
    And I should see "Please check your email and click on the confirm link"
    And I should see "to finalize confirming your new email address."
    And I should be on the Home page

  Scenario: I give the wrong current password
    Given I am a user with an account
    And  I sign in
    When I visit the home page
    And I click on Account
    And I click on Change Email Address
    Then I should be on the Change Email Address page
    When I enter "changed@example.com" in the user_email field
    And I enter "wrong" in the user_current_password field
    And I click button Update
    Then I should see "is invalid"
    And I should be on the Change Email Address page

  Scenario: I leave the password blank
    Given I am a user with an account
    And  I sign in
    When I visit the home page
    And I click on Account
    And I click on Change Email Address
    Then I should be on the Change Email Address page
    When I enter "changed@example.com" in the user_email field
    And I click button Update
    Then I should see "can't be blank"
    And I should be on the Change Email Address page

  Scenario: Edit account level settings - VAT enabled
    Given I am a user with an account
    And  I sign in
    When I visit the home page
    And I click on Account
    And I click on Manage Subscription
    Then I should be on the Account page
    When I click on Edit
    And I check VAT Enabled?
    And I click button Save
    Then I should be on the Account page
    And VAT Enabled? should be checked
