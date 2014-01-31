require 'spec_helper'

describe Customer do

  it "fails validation with no name (using error_on)" do
    expect(Customer.new).to have(1).error_on(:name)
  end

  it "passes validation with a name" do
    expect(Customer.new(name: "Me")).to have(:no).error_on(:name)
  end

  it "fails validation on no account ID" do
    expect(Customer.new).to have(1).error_on(:account_id)
  end

  it "passes validation with an account ID" do
    expect(Customer.new(account_id: 1)).to have(:no).error_on(:account_id)
  end

  it "fails validation with no name expecting a specific message" do
    expect(Customer.new.errors_on(:name)).to include("can't be blank")
  end

  it 'knows the sum of its bills' do
    customer = FactoryGirl.create(:customer)
    bill = FactoryGirl.create(:bill, customer_id: customer.id, amount: 10 )
    bill2 = FactoryGirl.create(:bill, customer_id: customer.id, amount: 10 )
    customer.total.should eq 20
  end

  it 'knows the sum of its bills and ignores others' do
    customer = FactoryGirl.create(:customer)
    another_customer = FactoryGirl.create(:customer)
    bill = FactoryGirl.create(:bill, customer_id: customer.id, amount: 10 )
    bill2 = FactoryGirl.create(:bill, customer_id: another_customer.id, amount: 10 )
    customer.total.should eq 10
  end

  it "will not destroy itself if it has bills" do
    customer = FactoryGirl.create(:customer)
    bill = FactoryGirl.create(:bill, customer_id: customer.id, amount: 10 )
    customer.destroy
    expect(Customer.count).to eq 1
  end

end
