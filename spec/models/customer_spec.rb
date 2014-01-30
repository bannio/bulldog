require 'spec_helper'

describe Customer do

  it 'is invalid without a name' do
    @customer = FactoryGirl.build(:customer, name: "")
    @customer.should_not be_valid
  end

  it 'knows the sum of its bills' do
    @customer = FactoryGirl.create(:customer)
    @bill = FactoryGirl.create(:bill, customer_id: @customer.id, amount: 10 )
    bill2 = FactoryGirl.create(:bill, customer_id: @customer.id, amount: 10 )
    bill3 = FactoryGirl.create(:bill, amount: 10 )
    @customer.total.should eq 20
  end

end
