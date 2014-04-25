Given(/^I am on the New Invoice page$/) do
  visit '/invoices/new'
end

Given(/^I select the customer (.*?)$/) do |customer|
  select customer,    from: 'invoice_customer_id'
end

Then(/^I should see a (.*?) button$/) do |btn|
  find_link(btn) || find_button(btn)
end

Given(/^I have created the (.*?) invoice$/) do |customer|
  steps %{
    Given I am on the New Invoice page
    And I select "#{customer}" as the invoice customer
    And I change the comment to "My business invoice"
    And I click button Create Invoice
    And I click button Save Changes
  }
end

Given(/^I have the (.*?) invoice$/) do |customer|
  customer = Customer.find_by_name(customer)
  invoice = Invoice.new(account_id: @account.id, 
                       customer_id: customer.id, 
                       date: Time.now,
                       comment: "My business invoice")
  bills = Bill.uninvoiced.where(customer_id: customer.id)
  invoice.number = Invoice.next_number(@account)
  invoice.total =bills.sum(:amount)
  invoice.save
  bills.each {|bill| bill.update_attribute(:invoice_id, invoice.id)}
end

Given(/^I am on the invoices index page$/) do
  visit '/invoices/'
end

When(/^I change the (.*?) to "(.*?)"$/) do |field, value|
  fill_in "invoice_#{field}", with: value
end

Given(/^I am on the edit page for this invoice$/) do
  id = Invoice.last.id
  visit "/invoices/#{id}/edit"
end

Then(/^I should see (\d+) bills?$/) do |arg1|
  expect(all("table#bill_table tr").count - 2).to eq arg1
end

When(/^I check one bill and click Save Changes$/) do
  within(:xpath, "//table[@id='bill_table']/tbody/tr[1]") do
    check('bill_ids_')
  end
  click_button('Save Changes')
end

Then(/^I should see (\d+) invoices$/) do |arg1|
  expect(all("table#invoice_table tr").count - 1).to eq arg1
end

Then(/^There is a search field for comment$/) do
  page.has_selector?("#invoices_search")
end

When(/^I type "(.*?)" in the search field and press enter$/) do |search|
  fill_in 'search', with: search
  click_button('Filter')
end

Given /^I have the following invoices$/ do |table|
  #puts table.raw
  table.raw.each do |row|
      number   = row[0]
      customer = Customer.find_or_create_by(name: row[1], account_id: @account.id)
      comment  = row[2]
      date     = row[3]
      total    = row[4]
      invoice  = FactoryGirl.create(:invoice,
                        account_id: @account.id,     # assumes user with an account already called
                        number: number,
                        customer_id: customer.id,
                        date: date, 
                        comment: comment,
                        total: total)
  end
end

When(/^I select "(.*?)" as the invoice customer$/) do |value|
  page.find("#s2id_invoice_customer_id b" ).click
  page.find(".select2-drop-active .select2-search .select2-input").set(value)
  page.find(".select2-drop-active .select2-search .select2-input").native.send_keys(:return)
end

When(/^I fill in header with "(.*?)"$/) do |value|
  page.find("#s2id_invoice_header_id b" ).click
  page.find(".select2-drop-active .select2-search .select2-input").set(value)
  page.find(".select2-drop-active .select2-search .select2-input").native.send_keys(:return)
end

When(/^I click the Delete button and confirm OK$/) do
  page.evaluate_script("window.confirm = function(msg) { return true; }")
  find_link('Delete').click
end

And(/^I wait$/) do
  sleep 1
end

Then(/^I am on the show page for this invoice$/) do
  id = Invoice.last.id
  visit "/invoices/#{id}"
end
