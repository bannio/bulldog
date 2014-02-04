require 'spec_helper'

describe Customer do

  let(:account){mock_model Account, current_id: 1}
  let!(:customer_one) { Customer.create(name: "Customer1", account_id: 1) }
  let!(:customer_two) { Customer.create(name: "Customer2", account_id: 2) }

  it "fails validation with no name (using error_on)" do
    expect(Customer.new).to have(1).error_on(:name)
  end

  it "passes validation with a name" do
    expect(Customer.new(name: "Me")).to have(:no).error_on(:name)
  end

  it "fails validation on no account ID" do
    expect(Customer.new(account_id: "")).to have(1).error_on(:account_id)
  end

  it "passes validation with an account ID" do
    expect(Customer.new(account_id: 1)).to have(:no).error_on(:account_id)
  end

  it "fails validation with no name expecting a specific message" do
    expect(Customer.new.errors_on(:name)).to include("can't be blank")
  end

  it 'knows the sum of its bills' do
    bill = FactoryGirl.create(:bill, customer_id: customer_one.id, amount: 10 )
    bill2 = FactoryGirl.create(:bill, customer_id: customer_one.id, amount: 10 )
    customer_one.total.should eq 20
  end

  it 'knows the sum of its bills and ignores others' do
    bill = FactoryGirl.create(:bill, customer_id: customer_one.id, amount: 10 )
    bill2 = FactoryGirl.create(:bill, customer_id: customer_two.id, amount: 10 )
    customer_one.total.should eq 10
  end

  it "will not destroy itself if it has bills" do
    bill = FactoryGirl.create(:bill, customer_id: customer_one.id, amount: 10, account_id: 1 )
    customer_one.destroy
    expect(Customer.unscoped.count).to eq 2
  end

    it "will destroy itself if it has no bills" do
    customer_one.destroy
    expect(Customer.unscoped.count).to eq 1
  end

  # it "has a default scope by account" do
  #   Customer.all.to_a.should eq [customer_one]
  # end
end
