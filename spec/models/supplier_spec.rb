require 'rails_helper'

describe Supplier do
  it 'is invalid without a name' do
    @supplier = FactoryBot.build(:supplier, name: "")
    expect(@supplier).to_not be_valid
  end

  it 'knows the sum of its bills' do
    @supplier = FactoryBot.create(:supplier)
    bill = FactoryBot.create(:bill, supplier_id: @supplier.id, amount: 10 )
    bill2 = FactoryBot.create(:bill, supplier_id: @supplier.id, amount: 10 )
    bill3 = FactoryBot.create(:bill, amount: 10 )

    expect(@supplier.total).to eq 20
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
    @supplier = FactoryBot.create(:supplier)
    bill = FactoryBot.create(:bill, supplier_id: @supplier.id, amount: 10 )
    expect{
      @supplier.destroy
    }.to_not change(Supplier, :count)

  end

  it "can reassign its bills to another" do
    supplier = FactoryBot.create(:supplier, name: "one")
    supplier2 = FactoryBot.create(:supplier, name: "two")
    bill = FactoryBot.create(:bill, supplier_id: supplier.id )
    bill2 = FactoryBot.create(:bill, supplier_id: supplier2.id )
    supplier.reassign_bills_to("two")
    expect(bill.reload.supplier_id).to eq supplier2.id
  end
end
