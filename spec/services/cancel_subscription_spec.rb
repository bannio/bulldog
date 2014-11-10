require 'rails_helper'

describe CancelSubscription do

  let(:account){ Account.new(state: "trialing") }
  let(:customer){ double('stripe_customer').as_null_object }

  it "changes account state to closed" do
    allow(RetrieveCustomer).to receive(:call).and_return(customer)
    CancelSubscription.call(account)
    expect(account.closed?).to be true
  end

  it "deletes Stripe subscription" do
    allow(RetrieveCustomer).to receive(:call).and_return(customer)
    allow(customer).to receive_message_chain(:subscriptions, :first, :id)
    expect(customer).to receive_message_chain(:subscriptions, :retrieve, :delete)
    CancelSubscription.call(account)
  end
end