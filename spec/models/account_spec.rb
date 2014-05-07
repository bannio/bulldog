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

  it "sets up the settings entry" do
    @user = FactoryGirl.create(:user)
    account = Account.create(user_id: @user.id, name: "test")
    expect(account.setting).to be_valid
  end
end
