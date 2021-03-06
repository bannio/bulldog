require 'rails_helper'

describe Customer do

  # let(:account){mock_model Account, current_id: 1}
  let!(:account) {FactoryBot.create(:account)}
  let!(:customer_one) { Customer.create(name: "Customer1", account_id: account.id) }
  let!(:customer_two) { Customer.create(name: "Customer2", account_id: 2) }
  let!(:customer_three) {Customer.create(name: "Customer 3", account_id: account.id)}

  it "fails validation with no name or account id" do
    customer = Customer.new
    customer.valid?
    expect(customer.errors[:name]).to_not be_empty
    expect(customer.errors[:account_id]).to_not be_empty
  end

  it "rejects a duplicate name in same account scope" do

    customer_one.save
    customer = Customer.new(name: "Customer1", account_id: account.id)
    expect(customer).to_not be_valid
  end
  it "accepts a duplicate name in different account scope" do
    customer_one.save
    customer = Customer.new(name: "Customer1", account_id: 2)
    expect(customer).to be_valid
  end

  it "passes validation with a name and account id" do
    customer = Customer.new(name: "Me", account_id: 1)
    customer.valid?
    expect(customer.errors).to be_empty
  end

  it "fails validation on no account ID" do
    customer = Customer.new
    customer.valid?
    expect(customer.errors[:account_id]).to_not be_empty
  end

  it "fails validation with no name expecting a specific message" do
    customer = Customer.new
    customer.valid?
    expect(customer.errors[:name]).to include("can't be blank")
  end

  it 'knows the sum of its bills' do
    bill = FactoryBot.create(:bill, customer_id: customer_one.id, amount: 10 )
    bill2 = FactoryBot.create(:bill, customer_id: customer_one.id, amount: 10 )
    expect(customer_one.total).to eq 20
  end

  it 'knows the sum of its bills and ignores others' do
    bill = FactoryBot.create(:bill, customer_id: customer_one.id, amount: 10 )
    bill2 = FactoryBot.create(:bill, customer_id: customer_two.id, amount: 10 )
    expect(customer_one.total).to eq 10
  end

  it "will not destroy itself if it has bills" do
    bill = FactoryBot.create(:bill, customer_id: customer_one.id, amount: 10, account_id: 1 )
    customer_one.destroy
    expect(Customer.unscoped.count).to eq 3
  end

  it "will destroy itself if it has no bills" do
    customer_one.destroy
    expect(Customer.unscoped.count).to eq 2
  end

  it "only allows one default customer within an account" do
    # customer_three = Customer.create(name: "Customer 3", account_id: 1)
    customer_one.is_default = true
    customer_one.save
    expect(customer_one.is_default?).to be_truthy
    customer_two.is_default = true
    customer_two.save
    customer_three.is_default = true
    customer_three.save
    # customer 3 replaces customer 1 as default
    expect(customer_one.reload.is_default?).to be_falsey
    expect(customer_two.is_default?).to be_truthy
    expect(customer_three.is_default?).to be_truthy
  end

  it "allows removal of default flag" do
    customer_one.is_default = true
    customer_one.save
    expect(customer_one.is_default).to be_truthy
    customer_one.update_attribute(:is_default, false)
    expect(customer_one.is_default).to be_falsey
  end

  # it "has a default scope by account" do
  #  expect( Customer.all.to_a).to eq [customer_one]
  # end
end
