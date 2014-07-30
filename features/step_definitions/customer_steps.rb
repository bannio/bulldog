Then(/^customer "(.*?)" is the default$/) do |customer|
  expect(Customer.find_by_name(customer).is_default).to be_truthy
end