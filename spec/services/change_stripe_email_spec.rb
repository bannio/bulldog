require 'rails_helper'
require 'stripe_mock'

describe ChangeStripeEmail do

  before { StripeMock.start }
  # before { StripeMock.toggle_debug(true) }
  after { StripeMock.stop }
  
  let(:account){ Account.new(
    stripe_customer_token: "cust",
    email: "oldone@example.com"
    ) 
  }

  # let(:change_email){ ChangeStripeEmail.new(account) }
  # let(:customer){ double('stripe_customer').as_null_object }
  let(:customer){ Stripe::Customer.create({
        id: 'cust',
        email: "oldone@example.com"
        }) }

  describe "change" do
    it "retrieves the stripe customer" do
      expect(Stripe::Customer).to receive(:retrieve).with("cust")
      ChangeStripeEmail.new(account).change
    end
    it "updates the stripe email" do
      the_customer = customer
      account.email = "newone@example.com"
      ChangeStripeEmail.new(account).change
      my_customer = Stripe::Customer.retrieve('cust')
      expect(my_customer.email).to eq "newone@example.com"
    end
    it "returns false if no customer token in account" do
      account.stripe_customer_token = ""
      expect(ChangeStripeEmail.new(account).change).to be_falsey
      expect(Stripe::Customer).not_to receive(:retrieve)
      ChangeStripeEmail.new(account).change
    end
    it "returns false if stripe customer not found" do
      account.stripe_customer_token = "badone"
      expect(ChangeStripeEmail.new(account).change).to be_falsey
      ChangeStripeEmail.new(account).change
    end
    it "adds error messages to account" do
      account.stripe_customer_token = "badone"
      ChangeStripeEmail.new(account).change
      expect(account.errors[:base]).to include('No such customer: badone')
    end
  end
end