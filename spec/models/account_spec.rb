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
    # allow_any_instance_of(Account).to receive(:get_customer).and_return(true)
    # allow_any_instance_of(Account).to receive(:process_sale).and_return(true)
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

  describe "email validation" do
    it "validates email not already in use" do
      user = FactoryGirl.create(:user, email: "reused@example.com")
      expect(Account.new(attributes_for(:account).merge(email: "reused@example.com"))).to_not be_valid
    end

    it "validates email not already in use - regardless of case" do
      user = FactoryGirl.create(:user, email: "reusED@example.com")
      expect(Account.new(attributes_for(:account).merge(email: "REused@example.com"))).to_not be_valid
    end

    context "when email already in use by another account" do
      it "it  not valid" do
        otheraccount = FactoryGirl.create(:account, email: "reused@example.com")
        account = Account.new(attributes_for(:account).merge(email: "reused@example.com"))
        expect(account).to_not be_valid
      end
    end
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

  describe "active?" do

    it "false when plan_id empty" do
      account = Account.new()
      expect(account.active?).to be_falsey
    end

    it "true when plan_id 1" do
      account = Account.new()
      account.plan_id = 1
      expect(account.active?).to be_truthy
    end

    it "false when plan_id blank" do
      account = Account.new()
      account.plan_id = ""
      expect(account.active?).to be_falsey
    end

    it "false when plan_id 0" do
      account = Account.new()
      account.plan_id = 0
      expect(account.active?).to be_falsey
    end

  end

  it "can find a customer" do
    # allow_any_instance_of(Account).to receive(:get_customer).and_return(true)
    # allow_any_instance_of(Account).to receive(:process_sale).and_return(true)
    account = create(:account)
    customer = create(:customer, account_id: account.id)
    expect(account.customer(customer.id)).to eq customer
  end

  it "can find a supplier" do
    account = create(:account)
    supplier = create(:supplier, account_id: account.id)
    expect(account.supplier(supplier.id)).to eq supplier
  end

  it "can find a category" do
    account = create(:account)
    category = create(:category, account_id: account.id)
    expect(account.category(category.id)).to eq category
  end

  it "can find a bill" do
    account = create(:account)
    bill = create(:bill, account_id: account.id)
    expect(account.bill(bill.id)).to eq bill
  end

  it "can find an invoice" do
    account = create(:account)
    invoice = create(:invoice, account_id: account.id)
    expect(account.invoice(invoice.id)).to eq invoice
  end

  it "sets up the settings entry" do
    allow_any_instance_of(Account).to receive(:get_customer).and_return(true)
    allow_any_instance_of(Account).to receive(:process_sale).and_return(true)
    account = Account.create(attributes_for(:account))
    expect(account.setting).to be_valid
  end

  describe "process_subscription" do
    before do
      Stripe::Plan.create(
        currency: "gbp",
        name: "Test",
        amount: 2000,
        interval: "year",
        interval_count: 1,
        trial_period_days: 0,
        id: 1
      )
    end

    it "creates a Stripe customer" do
      card_token = "a card" #StripeMock.generate_card_token(last4: "9191", exp_year: 2016)
      account = Account.new(
        name: "new customer", 
        email: "54321@example.com", 
        stripe_card_token: card_token,
        plan_id: 1)
      account.process_subscription
      expect(account.stripe_customer_token).to_not be_nil
    end

    context "with stripe error" do
      before(:each) do
        allow(Stripe::Customer).to receive(:create).with(anything()).and_raise("Stripe::InvalidRequestError")
      end

      it "raises an error" do
        account = Account.new(attributes_for(:account).merge(user_id: "", stripe_card_token: "void_card"))
        expect{account.process_subscription}.to raise_error("Stripe::InvalidRequestError")
      end
    end
  end

  describe "process_sale" do
    it "instantiates ProcessSale (until we fix this)" do
      account = Account.new(@attr)
      expect(ProcessSale).to receive_message_chain(:new, :process)
      account.send(:process_sale)
    end
    # it "sends process message to sale" do
    #   account = Account.new(@attr)
    #   expect_any_instance_of(Sale).to receive(:process!)
    #   account.send(:process_sale)
    # end

    # it "returns false if sale errors" do
    #   account = Account.new(@attr)
    #   allow_any_instance_of(Sale).to receive(:process!)
    #   allow_any_instance_of(Sale).to receive(:errored?).and_return(true)
    #   expect(account.send(:process_sale)).to be_falsey
    # end
    # it "returns true if sale finished" do
    #   account = Account.new(@attr)
    #   allow_any_instance_of(Sale).to receive(:errored?).and_return(false)
    #   allow_any_instance_of(Sale).to receive(:finished?).and_return(true)
    #   expect(account.send(:process_sale)).to be_truthy
    # end
    # it "updates card info when sale finished" do
    #   account = Account.new(@attr)
    #   allow_any_instance_of(Sale).to receive(:card_last4).and_return(1234)
    #   allow_any_instance_of(Sale).to receive(:card_expiration).and_return("2016-01-01".to_date)
    #   allow_any_instance_of(Sale).to receive(:errored?).and_return(false)
    #   allow_any_instance_of(Sale).to receive(:finished?).and_return(true)
    #   expect(account.send(:process_sale)).to be_truthy
    #   expect(account.card_last4).to eq 1234
    #   expect(account.card_expiration).to eq "2016-01-01".to_date
    # end
  end

  # describe "process_cancellation" do
  #   it "sends cancel message to sale" do
  #     account = Account.new(@attr)
  #     expect_any_instance_of(Sale).to receive(:cancel!)
  #     account.send(:process_cancellation)
  #   end
  #   it "returns false if sale errors" do
  #     account = Account.new(@attr)
  #     allow_any_instance_of(Sale).to receive(:cancel!)
  #     allow_any_instance_of(Sale).to receive(:errored?).and_return(true)
  #     expect(account.send(:process_cancellation)).to be_falsey
  #   end
  #   it "returns true if sale finished" do
  #     account = Account.new(@attr)
  #     allow_any_instance_of(Sale).to receive(:cancel!)
  #     allow_any_instance_of(Sale).to receive(:errored?).and_return(false)
  #     allow_any_instance_of(Sale).to receive(:finished?).and_return(true)
  #     expect(account.send(:process_cancellation)).to be_truthy
  #   end
  #   it "blanks out next invoice date" do
  #     account = Account.new(@attr.merge(next_invoice: "2014-07-18".to_date))
  #     allow_any_instance_of(Sale).to receive(:cancel!)
  #     allow_any_instance_of(Sale).to receive(:errored?).and_return(false)
  #     allow_any_instance_of(Sale).to receive(:finished?).and_return(true)
  #     account.send(:process_cancellation)
  #     expect(account.next_invoice).to be_nil
  #   end
  #   it "sets plan_id to zero" do
  #     account = Account.new(@attr)
  #     allow_any_instance_of(Sale).to receive(:cancel!)
  #     allow_any_instance_of(Sale).to receive(:errored?).and_return(false)
  #     allow_any_instance_of(Sale).to receive(:finished?).and_return(true)
  #     account.send(:process_cancellation)
  #     expect(account.plan_id).to eq 0
  #   end
  # end

  describe "create_user" do
    it "adds the user_id to itself" do
      account = Account.new(attributes_for(:account))
      account.create_user
      expect(account.user_id).to_not be_nil
    end
  end

  # describe "process_changes" do
  #   before :each do
  #     @account = create(:account)
  #   end
  #   it "calls process sale if plan changes and plan_id not 0" do
  #     @account.plan_id = 2
  #     expect(@account).to receive(:process_sale)
  #     @account.save
  #   end
  #   it "calls process cancellation if plan changes to 0" do
  #     @account.plan_id = 0
  #     expect(@account).to receive(:process_cancellation)
  #     @account.save
  #   end
  #   it "calls email change if email changes" do
  #     @account.email = "newemail@example.com"
  #     expect(@account).to receive(:change_email)
  #     @account.save
  #   end
  #   it "sets vat_enabled to false if change to personal plan" do
  #     allow_any_instance_of(Sale).to receive(:finished?).and_return(true)
  #     @account.vat_enabled = true
  #     @account.plan_id = 2
  #     @account.save           # account now business and vat_enabled true
  #     @account.plan_id = 1    # 
  #     @account.save           # simulate downgrade to personal plan
  #     expect(@account.vat_enabled).to be_falsey
  #   end
  #   it "leaves vat_enabled true if change to business plan" do
  #     allow_any_instance_of(Sale).to receive(:finished?).and_return(true)
  #     @account.vat_enabled = true
  #     @account.plan_id = 2
  #     @account.save           # account now business and vat_enabled true
  #     @account.plan_id = 3    # 
  #     @account.save           # simulate upgrade to annual plan
  #     expect(@account.vat_enabled).to be_truthy
  #   end
  # end

  # describe "change_email" do
  #   it "updates Stripe customer" do
  #     customer = Stripe::Customer.create({
  #       id: 'my_customer',
  #       email: "oldone@example.com"
  #       })
  #     account = create(:account, email: "oldone@example.com", stripe_customer_token: "my_customer")
  #     account.email = "newone@example.com"
  #     account.send(:change_email)
  #     customer = Stripe::Customer.retrieve('my_customer')
  #     expect(customer.email).to eq "newone@example.com"
  #   end
  # end

  describe "update_card" do

    it "updates expiry date and last4" do
      card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 1984, exp_month: 10)
      cus = Stripe::Customer.create(card: card_token)
      card_token_2 = StripeMock.generate_card_token(last4: "1234", exp_year: 1952, exp_month: 10)
      account = create(:account, stripe_customer_token: cus.id)
      account.update_card(card_token_2)
      expect(account.card_last4).to eq 1234
      expect(account.card_expiration).to eq "Wed, 01 Oct 1952".to_date
    end

    it "raises an error when Stripe customer missing" do
      allow(Stripe::Customer).to receive(:retrieve).and_raise("Stripe::InvalidRequestError")
      card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 1984, exp_month: 10)
      cus = Stripe::Customer.create(card: card_token)
      card_token_2 = StripeMock.generate_card_token(last4: "1234", exp_year: 1952, exp_month: 10)
      account = create(:account, stripe_customer_token: cus.id)
      expect {account.update_card(card_token_2)}.to raise_error("Stripe::InvalidRequestError")
    end

    it "returns true on success" do
      card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 1984, exp_month: 10)
      cus = Stripe::Customer.create(card: card_token)
      card_token_2 = StripeMock.generate_card_token(last4: "1234", exp_year: 1952, exp_month: 10)
      account = create(:account, stripe_customer_token: cus.id)
      expect(account.update_card(card_token_2)).to be_truthy
    end

    it "returns false on failure" do
      # allow(Stripe::Customer).to receive(:retrieve).and_raise("Stripe::InvalidRequestError")
      allow(Stripe::Customer).to receive(:retrieve).and_return(false)
      card_token = StripeMock.generate_card_token(last4: "9191", exp_year: 1984, exp_month: 10)
      cus = Stripe::Customer.create(card: card_token)
      card_token_2 = StripeMock.generate_card_token(last4: "1234", exp_year: 1952, exp_month: 10)
      account = create(:account, stripe_customer_token: cus.id)
      expect(account.update_card(card_token_2)).to be_falsey
    end
  end

  describe "add_to_subscriber_list" do
    before do
      mailchimp = double('mailchimp').as_null_object
      allow(Mailchimp::API).to receive(:new).and_return(mailchimp)
    end

    it "responds to add_to_subscriber_list" do
      account = Account.new(email: "test@example.com", mail_list: "1") 
      expect(account.add_to_subscriber_list).to be_truthy
    end

    it "calls mailchimp if mail_list checked" do
      account = Account.new(email: "test@example.com", mail_list: "1")
      expect(account).to receive(:mailchimp)
      account.add_to_subscriber_list
    end

    it "does not call mailchimp if mail_list un-checked" do
      account = Account.new(email: "test@example.com", mail_list: "0")
      expect(account).not_to receive(:mailchimp)
      account.add_to_subscriber_list
    end
  end
end
