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

  it "requires a unique name within account" do
    supplier = create(:supplier, name: "duplicate")
    expect(build(:supplier, name: "duplicate")).to_not be_valid
    expect(build(:supplier, name: "duplicate", account_id: 99)).to be_valid
  end

  it "is not case sensitive when checking uniqueness" do
    supplier = create(:supplier, name: "Duplicate")
    expect(build(:supplier, name: "duplicate")).to_not be_valid
  end

  it "checks for bills before destroying" do
    @supplier = FactoryGirl.create(:supplier)
    bill = FactoryGirl.create(:bill, supplier_id: @supplier.id, amount: 10 )
    expect{
      @supplier.destroy
    }.to_not change(Supplier, :count)
    
  end

  it "can reassign its bills to another" do
    supplier = FactoryGirl.create(:supplier, name: "one")
    supplier2 = FactoryGirl.create(:supplier, name: "two")
    bill = FactoryGirl.create(:bill, supplier_id: supplier.id )
    bill2 = FactoryGirl.create(:bill, supplier_id: supplier2.id )
    supplier.reassign_bills_to("two")
    expect(bill.reload.supplier_id).to eq supplier2.id
  end
end
