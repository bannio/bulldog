require 'rails_helper'
require 'stripe_mock'

describe Account do

  it "is valid with valid attributes" do
    expect(Account.new(attributes_for(:account))).to be_valid
  end

  it "validates presence of email" do
    expect(Account.new(attributes_for(:account).merge(email: ""))).to_not be_valid
  end

  it "validates presence of plan_id" do
    expect(Account.new(attributes_for(:account).merge(plan_id: ""))).to_not be_valid
  end

  it "responds to vat_enabled?" do
    account = Account.new(vat_enabled: true)
    expect(account.vat_enabled?).to be_truthy
    account.vat_enabled = false
    expect(account.vat_enabled?).to be_falsey
  end

  it "responds to vat_allowed?" do
    account = Account.new(vat_enabled: true, plan_id: 2)
    expect(account.vat_allowed?).to be_truthy         # both true
    account.vat_enabled = false
    expect(account.vat_allowed?).to be_falsey        # plan true, account false
    account.plan_id = 1
    account.vat_enabled = true
    expect(account.vat_allowed?).to be_falsey        # plan false, account true
    account.vat_enabled = false
    expect(account.vat_allowed?).to be_falsey        # both false
  end

  it "responds to business?" do
    account = Account.new(plan_id: 1)
    expect(account.business?).to be_falsey
    account.plan_id = 2
    expect(account.business?).to be_truthy
    account.plan_id = nil
    expect(account.business?).to be_falsey
  end
  it "responds to personal?" do
    account = Account.new(plan_id: 1)
    expect(account.personal?).to be_truthy
    account.plan_id = 2
    expect(account.personal?).to be_falsey
    account.plan_id = nil
    expect(account.personal?).to be_falsey
  end

  describe "states" do

    let(:account){ Account.new }

    it "responds to states" do
      expect(account.pending?).to be true
      expect(account.trialing?).to be false
      expect(account.paid?).to be false
      expect(account.expired?).to be false
      expect(account.closed?).to be false
      expect(account.deleted?).to be false
    end

    it "sign_up changes from pending to trialing" do
      a = Account.new(state: "pending")
      a.sign_up
      expect(a.trialing?).to be true
    end

    it "add_card changes from expired to paying" do
      a = Account.new(state: "expired")
      a.add_card
      expect(a.paying?).to be true
    end

    it "add_card leaves trialing as trialing" do
      a = Account.new(state: "trialing")
      a.add_card
      expect(a.trialing?).to be true
    end

    it "add_card leaves paid as paid" do
      a = Account.new(state: "paid")
      a.add_card
      expect(a.paid?).to be true
    end


    it "charge suceeding changes from paying to paid" do
      a = Account.new(state: "paying")
      a.charge
      expect(a.paid?).to be true
    end

    it "add_card cannot change from pending to paid" do
      a = Account.new(state: "pending")
      expect{a.add_card}.to raise_error(AASM::InvalidTransition)
      expect(a.pending?).to be true
    end

    it "cannot delete paid account" do
      a = Account.new(state: "paid")
      expect{a.delete}.to raise_error(AASM::InvalidTransition)
      expect(a.paid?).to be true
    end

    it "add_card is allowed when charge_failed" do
      a = Account.new(state: "charge_failed")
      a.add_card
      expect(a.charge_failed?).to be true
    end
  end

  describe "active?" do

    it "true when trialing" do
      account = Account.new(state: "trialing")
      expect(account.active?).to be true
    end

    it "true when paid" do
      account = Account.new(state: "paid")
      expect(account.active?).to be true
    end

    it "false when expired" do
      account = Account.new(state: "expired")
      expect(account.active?).to be false
    end

    it "true when paying" do
      account = Account.new(state: "paying")
      expect(account.active?).to be true
    end

    it "false when closed" do
      account = Account.new(state: "closed")
      expect(account.active?).to be_falsey
    end

    it "false when state is empty" do
      account = Account.new()
      expect(account.active?).to be false
    end

  end

  describe "it can find" do

    let(:account){ create(:account) }

    it "can find a customer" do
      customer = create(:customer, account_id: account.id)
      expect(account.customer(customer.id)).to eq customer
    end

    it "can find a supplier" do
      supplier = create(:supplier, account_id: account.id)
      expect(account.supplier(supplier.id)).to eq supplier
    end

    it "can find a category" do
      category = create(:category, account_id: account.id)
      expect(account.category(category.id)).to eq category
    end

    it "can find a bill" do
      bill = create(:bill, account_id: account.id)
      expect(account.bill(bill.id)).to eq bill
    end

    it "can find an invoice" do
      invoice = create(:invoice, account_id: account.id)
      expect(account.invoice(invoice.id)).to eq invoice
    end
  end

  it "sets up the settings entry" do
    allow_any_instance_of(Account).to receive(:get_customer).and_return(true)
    allow_any_instance_of(Account).to receive(:process_sale).and_return(true)
    account = Account.create(attributes_for(:account))
    expect(account.setting).to be_valid
  end
end
