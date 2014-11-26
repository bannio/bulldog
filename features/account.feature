@account
Feature: Account
  To facilitate future subscription plans and to store information
  for VAT enabled etc. An account should be created after first
  sign in (following confirmation) and this should be editable.

  Background:
    Given I am not logged in
    And a Base Plan exists
    And a Business Monthly Plan exists
    And a Business Annual Plan exists
    And stripe-ruby-mock is running

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

  @javascript
  Scenario: I can change my email address
    Given I am a user with an account
    And  I sign in
    When I visit the Change Email Address page
    Then I should be on the Change Email Address page
    When I enter "changed@example.com" in the user_email field
    And I enter "changeme" in the user_current_password field
    And I click button Update
    Then I should see "You updated your account successfully, but"
    And I should see "we need to verify your new email address."
    And I should see "Please check your email and click on the confirm link"
    And I should see "to finalize confirming your new email address."
    And I should be on the Welcome page

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
    And the account is subscribed to a business plan
    And  I sign in
    When I visit the home page
    And I click on Account
    And I click on Manage Subscription
    Then I should be on the Account page
    When I click on Change Plan
    And I check VAT Enabled?
    And I click button Save
    Then I should be on the Account page
    And VAT Enabled? should be checked

  Scenario: Upgrade subscription plan
    Given I am a user with an account
    And the account has a valid Stripe Customer token
    And  I sign in
    When I visit the home page
    And I click on Account
    And I click on Manage Subscription
    Then I should be on the Account page
    And I should see "Personal"
    When I click on Change Plan
    Then I should see "Plan"
    And the Personal plan should be selected
    When I choose the Business Annual plan
    And I click button Save
    Then I should be on the Account page
    And I should see "Business Annual"

