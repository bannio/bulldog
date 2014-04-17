require 'spec_helper'

describe VatRate do
  before do
    @attr = {
      account_id: 1,
      name: "standard",
      rate: "20",
      active: true
    }
  end

  it "is valid with valid attributes" do
    expect(VatRate.new(@attr)).to be_valid
  end

  it "is invalid with no name" do
    expect(VatRate.new(@attr.merge(name: ""))).to_not be_valid
  end

  it "is invalid with no rate" do
    expect(VatRate.new(@attr.merge(rate: ""))).to_not be_valid
  end

  it "is invalid with non numeric rate" do
    expect(VatRate.new(@attr.merge(rate: "a"))).to_not be_valid
  end

  it "cannot be deleted if there are bills" do
    vat_rate = VatRate.new(@attr)
    vat_rate.save
    bill = FactoryGirl.create(:bill, vat_rate_id: vat_rate.id)
    expect{vat_rate.destroy}.to_not change(VatRate, :count)
  end

  it "can be deleted if there are no bills" do
    vat_rate = VatRate.new(@attr)
    vat_rate.save
    expect{vat_rate.destroy}.to change(VatRate, :count).by(-1)
  end

  it "responds to active?" do
    vat_rate = VatRate.new(@attr)
    expect(vat_rate.active?).to be_true
  end

  it "has a scope for active only" do
    vat_rate = VatRate.create(@attr)
    vat_rate2 = VatRate.create(@attr.merge(active: false))
    expect(VatRate.active.length).to eq 1
  end

end
