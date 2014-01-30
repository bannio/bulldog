require 'spec_helper'

describe Supplier do
  it 'is invalid without a name' do
    @supplier = FactoryGirl.build(:supplier, name: "")
    @supplier.should_not be_valid
  end

  it 'knows the sum of its bills' do
    @supplier = FactoryGirl.create(:supplier)
    bill = FactoryGirl.create(:bill, supplier_id: @supplier.id, amount: 10 )
    bill2 = FactoryGirl.create(:bill, supplier_id: @supplier.id, amount: 10 )
    bill3 = FactoryGirl.create(:bill, amount: 10 )

    @supplier.total.should eq 20
  end
end
