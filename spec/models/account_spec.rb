require 'spec_helper'

describe Account do
  it "validates presence of user_id" do
    expect(Account.new(user_id: "")).to_not be_valid
  end
  it "validates presence of name" do
    expect(Account.new(name: "")).to_not be_valid
  end

  it "responds to vat_enabled?" do
    account = Account.new(vat_enabled: true)
    expect(account.vat_enabled?).to be_true
    account.vat_enabled = false
    expect(account.vat_enabled?).to be_false
  end

  it "responds to include_bank?" do
    account = Account.new(include_bank: true)
    expect(account.include_bank?).to be_true
    account.include_bank = false
    expect(account.include_bank?).to be_false
  end
end
