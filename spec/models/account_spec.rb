require 'spec_helper'

describe Account do

  before(:each) do
    @attr = {
      name: "account name",
      email: "fred@example.com",
      plan_id: 1,
      user_id: 1
    }
  end

  it "is valid with valid attributes" do
    expect(Account.new(attributes_for(:account))).to be_valid
  end
  # it "validates presence of user_id" do
  #   expect(Account.new(attributes_for(:account).merge(user_id: ""))).to_not be_valid
  # end

  # Removed name validation (and field!?)
  # it "validates presence of name" do
  #   expect(Account.new(attributes_for(:account).merge(name: ""))).to_not be_valid
  # end

  it "validates presence of email" do
    expect(Account.new(attributes_for(:account).merge(email: ""))).to_not be_valid
  end

  it "validates presence of plan_id" do
    expect(Account.new(attributes_for(:account).merge(plan_id: ""))).to_not be_valid
  end

  it "responds to vat_enabled?" do
    account = Account.new(vat_enabled: true)
    expect(account.vat_enabled?).to be_true
    account.vat_enabled = false
    expect(account.vat_enabled?).to be_false
  end

  it "sets up the settings entry" do
    @user = FactoryGirl.create(:user)
    account = Account.create(attributes_for(:account))
    expect(account.setting).to be_valid
  end

  context "save with payment" do
    before(:each) do
      # sign_out @user
      stripe_customer = OpenStruct.new(id: "cust_id")
      Stripe::Customer.stub(:create).with(anything()).and_return(stripe_customer)
    end

    it "creates a user" do
      account = Account.new(attributes_for(:account).merge(user_id: ""))
      expect{account.save_with_payment}.to change(User, :count).by(1)
    end
  end

  context "with stripe error" do
    before(:each) do
      # Stripe::Customer.stub(:create).with(anything()).and_return("")
      Stripe::Customer.stub(:create).with(anything()).and_raise("Stripe::InvalidRequestError")
    end
    it "does not creates a user" do
      account = Account.new(attributes_for(:account).merge(user_id: ""))
      expect{account.save_with_payment}.to raise_error("Stripe::InvalidRequestError")
      # expect{account.save_with_payment}.to_not change(User, :count).by(1)
      expect(User.count).to eq 0
    end
  end

end
