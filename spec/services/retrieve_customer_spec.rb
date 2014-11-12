require 'rails_helper'

describe RetrieveCustomer do

  let(:account){ Account.new(stripe_customer_token: 'cus_123') }

  it "contacts Stripe" do
    expect(Stripe::Customer).to receive(:retrieve).with('cus_123')
    RetrieveCustomer.call(account)
  end

  it "retunrs false when there is an error" do
    allow(Stripe::Customer).to receive(:retrieve).and_raise(Stripe::StripeError)
    expect(RetrieveCustomer.call(account)).to be false
  end

  it "adds to account errors" do
    allow(Stripe::Customer).to receive(:retrieve).and_raise(Stripe::StripeError, "stripe error")
    RetrieveCustomer.call(account)
    expect(account.errors[:base]).to include('stripe error')
  end

end