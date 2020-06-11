def create_customer
  @user ||= create_user
  @account ||= FactoryBot.create(:account, user_id: @user.id)
  @customer = FactoryBot.create(:customer, account_id: @account.id)
end

def create_another_customer
  @another_user ||= create_another_user
  @another_account ||= FactoryBot.create(:account, user_id: @another_user.id)
  @another_customer = FactoryBot.create(:customer, account_id: @another_account.id,
                      name: "Another customer #{@another_account.id}")
end

Then(/^customer "(.*?)" is the default$/) do |customer|
  expect(Customer.find_by_name(customer).is_default).to be_truthy
end

When(/^I fill in customer details and click save$/) do
  fill_in 'customer_name', with: 'My Customer'
  fill_in 'customer_address', with: 'My House\n My Street\n My Town'
  fill_in 'customer_postcode', with: 'ABC 123'
  click_on 'Save'
end

Then(/^I should have a Customer record saved$/) do
  customer = Customer.find_by account_id: @account.id
  expect(customer).to be
end

Given(/^I have a customer$/) do
  create_customer
end

Given(/^I visit the Customers page$/) do
  visit '/customers'
end

Given(/^There is another account with a customer$/) do
  create_another_customer
end

Then(/^I should only see my customer$/) do
  page.should_not have_content 'Another'
end

Given(/^I type the other customers ID in the edit URL$/) do
  id = @another_customer.id
  visit "/customers/#{id}/edit"
end

Given(/^I have a customer "(.*?)"$/) do |name|
  @user ||= create_user
  @account ||= FactoryBot.create(:account, user_id: @user.id)
  @customer = FactoryBot.create(:customer, account_id: @account.id, name: name)
end

When(/^I create another "(.*?)"$/) do |name|
  visit new_customer_path
  fill_in 'customer_name', with: name
  click_on 'Save'
end

When(/^I edit the customer "(.*?)"$/) do |name|
  customer = Customer.find_by_name(name)
  visit edit_customer_path(customer)
end