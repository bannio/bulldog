Given /^I start with a total expenses balance of £(\d+\.*\d*)$/ do |amount|
  FactoryBot.create(:bill, amount: amount.to_i) if amount.to_i > 0
  Bill.sum(:amount).should == amount.to_i
end
Given /^I have a supplier (\w+)$/ do |supplier|
  FactoryBot.create(:supplier, name: supplier)
  Supplier.find_by_name(supplier).name.should == supplier
end

And /^I have a customer (\w+)$/ do |customer|
  FactoryBot.create(:customer, name: customer)
  Customer.find_by_name(customer).name.should == customer
end
And /^I have a category (\w+)$/ do |category|
  FactoryBot.create(:category, name: category)
  Category.find_by_name(category).name.should == category
end

When /^I add a bill for £(\d+\.*\d*)$/ do |amount|
  FactoryBot.create(:bill, amount: amount.to_i)
end

Given /^I have the following data already saved$/ do |table|
  table.raw.each do |row|
    FactoryBot.create(:customer, name: row[0], account_id: @account.id)
    FactoryBot.create(:supplier, name: row[1], account_id: @account.id)
    FactoryBot.create(:category, name: row[2], account_id: @account.id)
  end
end

# When /^I add a (\w+) bill from (\w+) for £(\d+\.*\d*)$/ do |customer, supplier, value|
#   fill_in 'bill_date',        with: Date.today
#   select supplier,            from: 'bill_supplier_id'
#   select customer,            from: 'bill_customer_id'
#   select 'Food',              from: 'bill_category_id'
#   fill_in 'bill_description', with: 'my bill'
#   fill_in 'bill_amount',      with: value
#   click_button 'Save'
# end

# When /^I add a (\w+) bill from (\w+) for £(\d+\.*\d*)$/ do |customer, supplier, value|
When /^I add a (\w+) bill from (\w+) for £(\d+\.*\d*)$/ do |customer, supplier, value|
# date fills in by default and the datepicker can get in the way so
# as no date is specified, let it default.
  # find('#bill_date')
  # fill_in 'bill_date',        with: Date.today.to_s(:db) + "\t"
  steps %{
    When I type "#{customer}" in the customer select field
    When I type "#{supplier}" in the supplier select field
    When I type "Food" in the category select field
  }
  fill_in 'bill_description', with: 'my bill'
  fill_in 'bill_amount',      with: value.to_i
  # click_button 'Save'
end

When(/^I leave the amount empty$/) do
  # fill_in 'bill_date',        with: Date.today.to_s(:db)
  steps %{
    When I type "Household" in the customer select field
    When I type "Asda" in the supplier select field
    When I type "Food" in the category select field
  }
  fill_in 'bill_description', with: 'my bill'
  # fill_in 'bill_amount',      with: value
  # click_button 'Save'
end

Then /^the total expenses should be £(\d+\.*\d*)$/ do |amount|
  # This one keeps going wrong so trying to give it some space by
  # first visiting home
  # visit '/home'
  total = @account.reload.bills.sum(:amount)
  # expect(total).to eq amount.to_i
  expect(total).to eq amount
end

Then /^the (\w+) customer total should be £(\d+\.*\d*)$/ do |customer, amount|
  Customer.find_by_name(customer).reload.total.should eq(amount.to_i)
end

Then /^the (\w+) supplier total should be £(\d+\.*\d*)$/ do |supplier, amount|
  Supplier.find_by_name(supplier).reload.total.should == amount.to_i
end

Given /^the supplier (\w+) does not exist$/ do |supplier|
  Supplier.find_by_name(supplier).should be_nil
end

When /^I am on the new bill screen$/ do
  visit '/bills'
  click_on 'New'
end

When(/^I am on the bills page$/) do
  visit '/bills'
end

When(/^I click for another new bill$/) do
  # modal should have closed. Wait for new link to be visible.
  page.execute_script("$('#bill_modal').modal('hide')")
  find_link('New')
  click_on 'New'
end

Given /^I have the following bills$/ do |table|
  #puts table.raw
  table.raw.each do |row|
      customer = Customer.find_or_create_by(name: row[0], account_id: @account.id)
      supplier = Supplier.find_or_create_by(name: row[1], account_id: @account.id)
      category = Category.find_or_create_by(name: row[2], account_id: @account.id)
      vat_rate = VatRate.find_or_create_by(name: row[6], account_id: @account.id) unless row[6].blank?
      date = row[3]
      description = row[4]
      amount = row[5]
      vat = row[7] || ""
      vat_rate_id = vat_rate ? vat_rate.id : ""
      bill = FactoryBot.create(:bill,
                        account_id:  @account.id,  # assumes user with an account already called
                        customer_id: customer.id,
                        supplier_id: supplier.id,
                        category_id: category.id,
                        date:        date,
                        description: description,
                        amount:      amount,
                        vat_rate_id: vat_rate_id,
                        vat:         vat)
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
  page.find_by_id("select2-bill_#{field}_id-container" ).click
  find('.select2-dropdown input.select2-search__field').send_keys("#{value}", :enter)
end

And(/^I press escape to reset select search field$/) do
  page.first('.select2-dropdown input.select2-search__field').send_keys(:escape)
end

When(/^I enter "(.*?)" in the (.*?) field$/) do |value, field|
  fill_in field, with: value
end

Given(/^another user has a bill$/) do
  create_another_account
  @another_bill = FactoryBot.create(:bill, account_id: @another_account.id)

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

Then(/^I should not see "(.*?)" in modal form$/) do |text|
  within('#bill_form') do
    expect(page).to_not have_content(text)
  end
end

Then(/^I should be on the "(.*?)" modal$/) do |text|
  within('#modal_title') do
    expect(page).to have_content(text)
  end
end

Then(/^I should see placeholder "(.*?)"$/) do |field|
  expect(page).to have_xpath("//input[@placeholder='#{field}']")
end

Then(/^I should not see placeholder "(.*?)"$/) do |field|
  expect(page).to_not have_xpath("//input[@placeholder='#{field}']")
end


