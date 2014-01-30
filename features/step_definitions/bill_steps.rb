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

When /^I add a (\w+) bill from (\w+) for £(#{CAPTURE_A_NUMBER})$/ do |customer, supplier, value|
  # cust = Customer.find_by_name(customer) # requires customer to be set up in background
  # supp = Supplier.find_by_name(supplier) # which makes this step unuseable elsewhere!!!
  # FactoryGirl.create(:bill, customer_id: cust.id, supplier_id: supp.id, amount: value)
  fill_in 'bill_date',        with: Date.today
  select supplier,            from: 'bill_supplier_id'
  select customer,            from: 'bill_customer_id'
  select 'Food',              from: 'bill_category_id'
  fill_in 'bill_description', with: 'my bill'
  fill_in 'bill_amount',      with: value
  click_button 'Save'
end

When(/^I leave the amount empty$/) do
  fill_in 'bill_date',        with: Date.today
  select 'Asda',              from: 'bill_supplier_id'
  select 'Household',         from: 'bill_customer_id'
  select 'Food',              from: 'bill_category_id'
  fill_in 'bill_description', with: 'my bill'
  # fill_in 'bill_amount',      with: value
  click_button 'Save'
end

Then /^the total expenses should be £(#{CAPTURE_A_NUMBER})$/ do |amount|
  Bill.sum(:amount).should == amount
end

Then /^the (\w+) customer total should be £(#{CAPTURE_A_NUMBER})$/ do |customer, amount|
  Customer.find_by_name(customer).total.should eq(amount)
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