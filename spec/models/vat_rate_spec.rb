require 'rails_helper'

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
    bill = FactoryBot.create(:bill, vat_rate_id: vat_rate.id)
    expect{vat_rate.destroy}.to_not change(VatRate, :count)
  end

  it "can be deleted if there are no bills" do
    vat_rate = VatRate.new(@attr)
    vat_rate.save
    expect{vat_rate.destroy}.to change(VatRate, :count).by(-1)
  end

  it "responds to active?" do
    vat_rate = VatRate.new(@attr)
    expect(vat_rate.active?).to be_truthy
  end

  it "has a scope for active only" do
    vat_rate = VatRate.create(@attr)
    vat_rate2 = VatRate.create(@attr.merge(active: false))
    expect(VatRate.active.length).to eq 1
  end

  it "can detect active duplicates by name" do
    ac = FactoryBot.create(:account)
    vat_rate = VatRate.new(@attr.merge(account_id: ac.id))
    vat_rate.save
    expect(VatRate.new(@attr.merge(account_id: ac.id))).to_not be_valid
  end

  it "checks if the vat % rate has been used" do
    vat_rate = VatRate.new(@attr)
    vat_rate.save
    bill = FactoryBot.create(:bill, vat_rate_id: vat_rate.id)
    vat_rate.update(rate: 15)
    expect(vat_rate).to_not be_valid
  end

  it "OK to change if the vat % rate has not been used" do
    vat_rate = VatRate.new(@attr)
    vat_rate.save
    vat_rate.update(rate: 15)
    expect(vat_rate).to be_valid
  end

end
