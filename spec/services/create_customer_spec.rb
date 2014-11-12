require 'rails_helper'

describe CreateCustomer do

  let(:account){ Account.new }
  let(:customer){ double('customer', id: "cus_123")}
  let(:te_date){ 1415615719 }

  it "creates a Stripe customer" do
    allow(customer).to receive_message_chain(
      :subscriptions, :data, :first, :trial_end).and_return(te_date)
    expect(Stripe::Customer).to receive(:create).and_return(customer)
    CreateCustomer.call(account)
  end

  it "adds to account errors if error" do
    allow(Stripe::Customer).to receive(:create).
      and_raise(Stripe::StripeError, "Stripe error")
    CreateCustomer.call(account)
    expect(account.errors[:base]).to include("Stripe error")
  end

  it "updates account stripe customer token" do
    allow(customer).to receive_message_chain(
      :subscriptions, :data, :first, :trial_end).and_return(te_date)
    allow(Stripe::Customer).to receive(:create).and_return(customer)
    CreateCustomer.call(account)
    expect(account.stripe_customer_token).to eq "cus_123"
  end

  it "updates account end_date" do
    allow(customer).to receive_message_chain(
      :subscriptions, :data, :first, :trial_end).and_return(te_date)
    allow(Stripe::Customer).to receive(:create).and_return(customer)
    CreateCustomer.call(account)
    expect(account.trial_end).to eq Time.at(te_date)
  end
end