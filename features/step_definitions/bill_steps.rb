Given /^I start with a total expenses balance of £(#{CAPTURE_A_NUMBER})$/ do |amount|
  FactoryGirl.create(:bill, amount: amount) if amount > 0
  Bill.sum(:amount).should == amount
end
Given /^I have a supplier (\w+)$/ do |supplier|
  FactoryGirl.create(:supplier, name: supplier)
  Supplier.find_by_name(supplier).name.should == supplier
end

And /^I have a customer (\w+)$/ do |customer|
  FactoryGirl.create(:customer, name: customer)
  Customer.find_by_name(customer).name.should == customer
end
And /^I have a category (\w+)$/ do |category|
  FactoryGirl.create(:category, name: category)
  Category.find_by_name(category).name.should == category
end

When /^I add a bill for £(#{CAPTURE_A_NUMBER})$/ do |amount|
  FactoryGirl.create(:bill, amount: amount)
end

Given /^I have the following data already saved$/ do |table|
  table.raw.each do |row|
    FactoryGirl.create(:customer, name: row[0], account_id: @account.id)
    FactoryGirl.create(:supplier, name: row[1], account_id: @account.id)
    FactoryGirl.create(:category, name: row[2], account_id: @account.id)
  end
end

# When /^I add a (\w+) bill from (\w+) for £(#{CAPTURE_A_NUMBER})$/ do |customer, supplier, value|
#   fill_in 'bill_date',        with: Date.today
#   select supplier,            from: 'bill_supplier_id'
#   select customer,            from: 'bill_customer_id'
#   select 'Food',              from: 'bill_category_id'
#   fill_in 'bill_description', with: 'my bill'
#   fill_in 'bill_amount',      with: value
#   click_button 'Save'
# end

When /^I add a (\w+) bill from (\w+) for £(#{CAPTURE_A_NUMBER})$/ do |customer, supplier, value|
  fill_in 'bill_date',        with: Date.today
  steps %{
    When I type "#{customer}" in the customer select field
    When I type "#{supplier}" in the supplier select field
    When I type "Food" in the category select field
  }
  fill_in 'bill_description', with: 'my bill'
  fill_in 'bill_amount',      with: value
  click_button 'Save'
end

When(/^I leave the amount empty$/) do
  fill_in 'bill_date',        with: Date.today
  steps %{
    When I type "Household" in the customer select field
    When I type "Asda" in the supplier select field
    When I type "Food" in the category select field
  }
  fill_in 'bill_description', with: 'my bill'
  # fill_in 'bill_amount',      with: value
  click_button 'Save'
end

Then /^the total expenses should be £(#{CAPTURE_A_NUMBER})$/ do |amount|
  Bill.sum(:amount).should == amount
end

Then /^the (\w+) customer total should be £(#{CAPTURE_A_NUMBER})$/ do |customer, amount|
  Customer.find_by_name(customer).reload.total.should eq(amount)
end

Then /^the (\w+) supplier total should be £(#{CAPTURE_A_NUMBER})$/ do |supplier, amount|
  Supplier.find_by_name(supplier).total.should == amount
end

Given /^the supplier (\w+) does not exist$/ do |supplier|
  Supplier.find_by_name(supplier).should be_nil
end

When /^I am on the new bill screen$/ do
  visit '/bills/new'
end

When(/^I am on the bills page$/) do
  visit '/bills'
end

Given /^I have the following bills$/ do |table|
  #puts table.raw
  table.raw.each do |row|
      customer = Customer.find_or_create_by(name: row[0], account_id: @account.id)
      supplier = Supplier.find_or_create_by(name: row[1], account_id: @account.id)
      category = Category.find_or_create_by(name: row[2], account_id: @account.id)
      date = row[3]
      description = row[4]
      amount = row[5]
      bill = FactoryGirl.create(:bill,
                        account_id: @account.id,     # assumes user with an account already called
                        customer_id: customer.id,
                        supplier_id: supplier.id, 
                        category_id: category.id, 
                        date: date, 
                        description: description,
                        amount: amount)
  end
end

When(/^I change the bill (.*?) to "(.*?)" and press save$/) do |field, value|
  fill_in field, with: value
  click_button 'Save'
end

Then(/^there is a link to add a new bill$/) do
  find_link('New').visible?
end

When(/^I type "(.*?)" in the (.*?) select field$/) do |value, field|
  page.find("#s2id_bill_#{field}_id b" ).click
  page.find(".select2-drop-active .select2-search .select2-input").set(value)
  page.find(".select2-drop-active .select2-search .select2-input").native.send_keys(:return)
end

When(/^I enter "(.*?)" in the (.*?) field$/) do |value, field|
  fill_in field, with: value
end

Given(/^another user has a bill$/) do
  create_another_account
  @another_bill = FactoryGirl.create(:bill, account_id: @another_account.id)

end

Given(/^I type in the other users bill ID in the \/bills\/ID\/edit URL$/) do
  visit "/bills/#{@another_bill.id}/edit"
end

Given(/^I am on the edit page for the first bill$/) do
  bill = Bill.first
  visit "/bills/#{bill.id}/edit"
end

# Then(/^I should see a Cancel button$/) do
#   find_link('Cancel').visible?
# end

When(/^I change the bill (.*?) to "(.*?)" and press Cancel$/) do |field, value|
  fill_in field, with: value
  click_link 'Cancel'
end

Then(/^I should see "(.*?)" in the "(.*?)" field$/) do |text, field|
  find_field(field).value.should eq text
end

Then(/^row (\d+) should include "(.*?)"$/) do |row, text|
  within("tbody") do
    expect(find("tr:nth-child(#{row.to_i})")).to have_content(text)
  end
end

Then(/^I should see "(.*?)" in modal form$/) do |text|
  within('#bill_form') do
    expect(page).to have_content(text)
  end
end

Then(/^I should be on the "(.*?)" modal$/) do |text|
  within('#modal_title') do
    expect(page).to have_content(text)
  end
end


