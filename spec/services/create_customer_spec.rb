require 'rails_helper'

describe CreateCustomer do

  let(:account){ Account.new }
  let(:customer){ double('customer', id: "cus_123")}

  it "creates a Stripe customer" do
    expect(Stripe::Customer).to receive(:create).and_return(customer)
    CreateCustomer.call(account)
  end

  it "adds to account errors if error" do
    allow(Stripe::Customer).to receive(:create).
      and_raise(Stripe::StripeError, "Stripe error")
    CreateCustomer.call(account)
    expect(account.errors[:base]).to include("Stripe error")
  end
end