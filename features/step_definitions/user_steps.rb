### UTILITY METHODS ###

def create_visitor
  @visitor ||= { :email => "example@example.com",
    :password => "changeme", :password_confirmation => "changeme" }
end

def create_another_visitor
  @another_visitor ||= { :email => "another.example@example.com",
    :password => "changeme", :password_confirmation => "changeme" }
end

def find_user
  @user ||= User.where(:email => @visitor[:email]).first
end

def find_another_user
  @another_user ||= User.where(:email => @another_visitor[:email]).first
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  visit '/sign_out'
end

def create_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:user, @visitor)
end

def create_another_user
  create_another_visitor
  delete_another_user
  @another_user = FactoryGirl.create(:user, @another_visitor)
end

def create_account
  @user ||= create_user
  @account = FactoryGirl.create(:account, user_id: @user.id)
end

def create_another_account
  @another_user ||= create_another_user
  @another_account = FactoryGirl.create(:account, user_id: @another_user.id)
end

def create_setting
  @setting = @account.create_setting
end

def create_customer
  @user ||= create_user
  @account ||= FactoryGirl.create(:account, user_id: @user.id)
  @customer = FactoryGirl.create(:customer, account_id: @account.id)
end

def create_another_customer
  @another_user ||= create_another_user
  @another_account ||= FactoryGirl.create(:account, user_id: @another_user.id)
  @another_customer = FactoryGirl.create(:customer, account_id: @another_account.id, 
                      name: "Another customer #{@another_account.id}")
end

def delete_user
  @user ||= User.where(:email => @visitor[:email]).first
  @user.destroy unless @user.nil?
end

def delete_another_user
  @another_user ||= User.where(:email => @another_visitor[:email]).first
  @another_user.destroy unless @another_user.nil?
end

def delete_account
  @user.account.destroy unless @user.account.nil?
end

def delete_another_account
  @another_user.account.destroy unless @another_user.account.nil?
end

def delete_customer
  @account.customers.first.destroy unless @account.customers.empty?
end

def delete_another_customer
  @another_account.customers.first.destroy unless @another_account.customers.empty?
end

def sign_up
  delete_user
  visit '/sign_up'
  # fill_in "user_name", :with => @visitor[:name]
  fill_in "user_email", :with => @visitor[:email]
  # fill_in "user_password", :with => @visitor[:password]
  # fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
  click_button "Sign up"
  find_user
end

def sign_in
  visit '/sign_in'
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  click_button "Sign in"
end

### GIVEN ###
Given /^I am not logged in$/ do
  visit '/sign_out'
end

Given /^I am logged in$/ do
  # create_user
  create_account
  sign_in
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I exist as an unconfirmed user$/ do
  create_unconfirmed_user
end

Given(/^I have no account$/) do
  delete_account if @user
end

Given(/^I have no customer$/) do
  # create_user
  delete_customer
end

Given(/^I am a user with an account$/) do
  create_account
end

### WHEN ###
When /^I sign in with valid credentials$/ do
  create_account
  sign_in
end

When /^I sign in with invalid credentials$/ do
  sign_in
end

When /^I sign in$/ do
  sign_in
end

When /^I sign out$/ do
  visit '/sign_out'
end

When /^I sign up with valid user data$/ do
  create_visitor
  sign_up
end

When(/^I sign up with just my email$/) do
  create_visitor
  sign_up
  # delete_user
  # visit '/sign_up'
  # fill_in "user_email", :with => @visitor[:email]
  # click_button "Sign up"
  # find_user
end

When(/^I enter account activation details$/) do
  fill_in 'user_account_name', with: 'My Account'
  fill_in 'user_password', with: 'password'
  fill_in 'user_password_confirmation', with: 'password'
  click_button 'Activate'

end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  sign_up
end

When /^I sign up without a password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "")
  sign_up
end

When /^I sign up without a password$/ do
  create_visitor
  @visitor = @visitor.merge(:password => "")
  sign_up
end

When /^I activate with a valid password$/ do
  # create_visitor
  # sign_up
  open_email(@visitor[:email])
  click_first_link_in_email
  fill_in 'user_account_name', with: 'My Account'
  fill_in 'user_password', with: 'password'
  fill_in 'user_password_confirmation', with: 'password'
  click_button 'Activate'
end

When /^I activate without a password$/ do
  create_visitor
  sign_up
  open_email(@visitor[:email])
  click_first_link_in_email
  fill_in 'user_account_name', with: 'My Account'
  fill_in 'user_password', with: ''
  fill_in 'user_password_confirmation', with: 'password'
  click_button 'Activate'
end

When /^I activate without a password confirmation$/ do
  create_visitor
  sign_up
  open_email(@visitor[:email])
  click_first_link_in_email
  fill_in 'user_account_name', with: 'My Account'
  fill_in 'user_password', with: 'password'
  fill_in 'user_password_confirmation', with: ''
  click_button 'Activate'
end

When /^I activate with a mismatched password confirmation$/ do
  create_visitor
  sign_up
  open_email(@visitor[:email])
  click_first_link_in_email
  fill_in 'user_account_name', with: 'My Account'
  fill_in 'user_password', with: 'password'
  fill_in 'user_password_confirmation', with: 'anotherpassword'
  click_button 'Activate'
end

When /^I sign up with a mismatched password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "changeme123")
  sign_up
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

When /^I edit my account details$/ do
  click_link "Account"
  click_link "Change Password"
  fill_in "user_password", :with => "newpassword"
  fill_in "user_password_confirmation", :with => "newpassword"
  fill_in "user_current_password", :with => @visitor[:password]
  click_button "Update"
end

When(/^I edit my account and change the email to "(.*?)"$/) do |email|
  click_link "Account"
  click_link "Change Email Address"
  fill_in "user_email", with: email
  fill_in "user_current_password", :with => @visitor[:password]
  click_button "Update"
end

# When /^I look at the list of users$/ do
#   visit '/'
# end

### THEN ###
Then /^I should be signed in$/ do
  page.should have_content "Sign out"
  page.should_not have_content "Sign up"
  page.should_not have_content "Sign in"
end

Then /^I should be signed out$/ do
  page.should have_content "Sign up"
  page.should have_content "Sign in"
  page.should_not have_content "Sign out"
end

Then /^I see an unconfirmed account message$/ do
  page.should have_content "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I should see a successful sign up message$/ do
  # page.should have_content "Welcome! You have signed up successfully."
  page.should have_content "A message with a confirmation link has been sent to your email address"
end

Then /^I should see an invalid email message$/ do
  page.should have_content "is invalid"
  # page.should have_content "Email is invalid"
end

Then /^I should see a missing password message$/ do
  page.should have_content "can't be blank"
  # page.should have_content "Password can't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  # page.should have_content "Password confirmation doesn't match"
  page.should have_content "doesn't match"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "doesn't match"
  # page.should have_content "Password confirmation doesn't match"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully"
end

Then /^I should see my name$/ do
  create_user
  page.should have_content @user[:name]
end

Given(/^I have a settings entry$/) do
  create_setting
end