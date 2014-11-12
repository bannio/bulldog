require 'rails_helper'
require 'stripe_mock'

describe ChangeStripeEmail do

  before { StripeMock.start }
  # before { StripeMock.toggle_debug(true) }
  after { StripeMock.stop }

  let(:account){ Account.new(
    stripe_customer_token: "cust",
    email: "newone@example.com"
    )
  }

  let(:customer){ Stripe::Customer.create({
        id: 'cust',
        email: "oldone@example.com"
        }) }

  describe "call" do
    it "retrieves the stripe customer" do
      expect(RetrieveCustomer).to receive(:call).and_return(customer)
      ChangeStripeEmail.call(account)
    end
    it "updates the stripe email" do
      allow(RetrieveCustomer).to receive(:call).and_return(customer)
      ChangeStripeEmail.call(account)
      my_customer = Stripe::Customer.retrieve('cust')
      expect(my_customer.email).to eq "newone@example.com"
    end
    it "adds error messages to account" do
      allow(RetrieveCustomer).to receive(:call).
        and_raise(Stripe::StripeError, 'stripe error')
      ChangeStripeEmail.call(account)
      expect(account.errors[:base]).to include('stripe error')
    end
    it "returns an account" do
      allow(RetrieveCustomer).to receive(:call).and_return(customer)
      expect(ChangeStripeEmail.call(account)).to eq account
    end
  end
end