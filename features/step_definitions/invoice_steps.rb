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
    And I select the customer #{customer}
    And I change the comment to "My business invoice"
    And I click button Create Invoice
  }
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
  (all("table#bill_table tr").count - 2) == arg1
end

When(/^I check one bill and click Update Invoice$/) do
  within(:xpath, "//table/tr[2]") do
    check('bill_ids_')
  end
  click_button('Update Invoice')
end
