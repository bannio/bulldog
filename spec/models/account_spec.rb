require 'rails_helper'
require 'stripe_mock'

describe Account do
  before { StripeMock.start }
  # before { StripeMock.toggle_debug(true) }
  after { StripeMock.stop }

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

  it "validates presence of email" do
    expect(Account.new(attributes_for(:account).merge(email: ""))).to_not be_valid
  end

  it "validates presence of plan_id" do
    expect(Account.new(attributes_for(:account).merge(plan_id: ""))).to_not be_valid
  end

  it "validates email not already in use" do
    user = FactoryGirl.create(:user, email: "reused@example.com")
    expect(Account.new(attributes_for(:account).merge(email: "reused@example.com"))).to_not be_valid
  end

  it "validates email not already in use - regardless of case" do
    user = FactoryGirl.create(:user, email: "reusED@example.com")
    expect(Account.new(attributes_for(:account).merge(email: "REused@example.com"))).to_not be_valid
  end

  it "responds to vat_enabled?" do
    account = Account.new(vat_enabled: true)
    expect(account.vat_enabled?).to be_truthy
    account.vat_enabled = false
    expect(account.vat_enabled?).to be_falsey
  end

  it "responds to vat_allowed?" do
    account = create(:account, vat_enabled: true, plan_id: 2)
    expect(account.vat_allowed?).to be_truthy         # both true
    account.vat_enabled = false
    expect(account.vat_allowed?).to be_falsey        # plan true, account false
    account.plan_id = 1
    account.vat_enabled = true
    expect(account.vat_allowed?).to be_falsey        # plan false, account true
    account.vat_enabled = false
    expect(account.vat_allowed?).to be_falsey        # both false
  end

  it "sets up the settings entry" do
    @user = FactoryGirl.create(:user)
    account = Account.create(attributes_for(:account))
    expect(account.setting).to be_valid
  end

  describe "save with customer" do
    before {Stripe::Plan.create(
      currency: "gbp",
      name: "Test",
      amount: 2000,
      interval: "year",
      interval_count: 1,
      trial_period_days: 0,
      id: 1)
    }
    it "creates a Stripe customer" do
      card_token = "a card" #StripeMock.generate_card_token(last4: "9191", exp_year: 2016)
      account = Account.new(
        name: "new customer", 
        email: "54321@example.com", 
        stripe_card_token: card_token,
        plan_id: 1)
      account.save_with_customer
      expect(account.stripe_customer_token).to_not be_nil
    end

    context "with stripe error" do
      before(:each) do
        allow(Stripe::Customer).to receive(:create).with(anything()).and_raise("Stripe::InvalidRequestError")
      end

      it "does not create an account" do
        account = Account.new(attributes_for(:account).merge(user_id: "", stripe_card_token: "void_card"))
        expect{account.save_with_customer}.to raise_error("Stripe::InvalidRequestError")
        expect(Account.count).to eq 0
      end
    end
    
    context "when email already in use by a user" do
      it "does not create an account" do
        user = FactoryGirl.create(:user, email: "reused@example.com")
        account = Account.new(attributes_for(:account).merge(email: "reused@example.com"))
        expect{account.save_with_customer}.to change(Account, :count).by(0)
      end
    end

    context "when email already in use by another account" do
      it "does not create an account" do
        otheraccount = FactoryGirl.create(:account, email: "reused@example.com")
        account = Account.new(attributes_for(:account).merge(email: "reused@example.com"))
        expect{account.save_with_customer}.to change(Account, :count).by(0)
      end
    end
  end

  describe "create_user" do
    it "adds the user_id to itself" do
      account = Account.new(attributes_for(:account))
      account.create_user
      expect(account.user_id).to_not be_nil
    end
  end

  # describe "save with payment" do
  #   before {Stripe::Plan.create(currency: "gbp",
  #    name: "Test",
  #    amount: 2000,
  #    interval: "year",
  #    interval_count: 1,
  #    trial_period_days: 0,
  #    id: 1)
  #   }
  #   it "creates a user" do
  #     card_token = "a card" #StripeMock.generate_card_token(last4: "9191", exp_year: 2016)
  #     account = Account.new(attributes_for(:account).merge(user_id: "", 
  #       email: "54321@example.com", stripe_card_token: card_token, plan_id: 1))
  #     expect{account.save_with_payment}.to change(User, :count).by(1)
  #   end

  #   it "adds the user id to itself" do
  #     card_token = "a card" #StripeMock.generate_card_token(last4: "9191", exp_year: 2016)
  #     account = Account.new(attributes_for(:account).merge(user_id: nil, 
  #       email: "54321@example.com", stripe_card_token: card_token, plan_id: 1))
  #     account.save_with_payment
  #     expect(account.reload.user_id).to_not be_nil
  #   end

  #   context "with stripe error" do
  #     before(:each) do
  #       allow(Stripe::Customer).to receive(:create).with(anything()).and_raise("Stripe::InvalidRequestError")
  #     end

  #     it "does not creates a user or an account" do
  #       account = Account.new(attributes_for(:account).merge(user_id: "", stripe_card_token: "void_card"))
  #       expect{account.save_with_payment}.to raise_error("Stripe::InvalidRequestError")
  #       expect(User.count).to eq 0
  #       expect(Account.count).to eq 0
  #     end
  #   end
    
  #   context "when email already in use by a user" do
  #     it "does not create a new user or an account" do
  #       user = FactoryGirl.create(:user, email: "reused@example.com")
  #       account = Account.new(attributes_for(:account).merge(email: "reused@example.com"))
  #       expect{account.save_with_payment}.to change(Account, :count).by(0)
  #       expect(User.count).to eq 1 
  #     end
  #   end
  # end

  describe "change account plan" do
    pending
  end
end
