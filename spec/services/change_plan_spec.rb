require 'rails_helper'

describe ChangePlan do

  let(:account){ Account.new(plan_id: 1) }
  let(:stripe_customer){ double('customer').as_null_object }
  let(:sub){ double('subscription', save: true) }

  it "returns an account" do
    allow(RetrieveCustomer).to receive(:call).and_return(stripe_customer)
    expect(ChangePlan.call(account)).to eq account
  end

  it "calls Stripe for a customer" do
    expect(RetrieveCustomer).to receive(:call).and_return(stripe_customer)
    ChangePlan.call(account)
  end

  it "updates Stripe" do
    allow(RetrieveCustomer).to receive(:call).and_return(stripe_customer)
    allow(stripe_customer).to receive_message_chain(:subscriptions, :first, :id)
    allow(stripe_customer).to receive_message_chain(:subscriptions, :retrieve).and_return(sub)
    allow(sub).to receive(:plan=)
    allow(sub).to receive(:trial_end)
    allow(sub).to receive(:trial_end=)
    expect(sub).to receive(:save)
    ChangePlan.call(account)
  end

  it "adds errors to account if Stripe errors" do
    allow(RetrieveCustomer).to receive(:call).and_return(stripe_customer)
    allow(stripe_customer).to receive_message_chain(:subscriptions, :first, :id).
      and_raise(Stripe::StripeError, 'stripe error')
    ChangePlan.call(account)
    expect(account.errors[:base]).to include('stripe error')
  end

  it "transitions to paying if closed" do
    account.state = "closed"
    allow(RetrieveCustomer).to receive(:call).and_return(stripe_customer)
    ChangePlan.call(account)
    expect(account.state).to eq "paying"
  end

  it "creates a subscription if one doesn't exist" do
    allow(RetrieveCustomer).to receive(:call).and_return(stripe_customer)
    allow(stripe_customer).to receive_message_chain(:subscriptions, :first).and_return(nil)
    expect(stripe_customer).to receive_message_chain(:subscriptions, :create).with({:plan=>1})
    ChangePlan.call(account)
  end

  it "sets the trial end to previous trial end if in the future" do
    t_end = Time.now + 1.day
    sub = double('subscription', save: true, trial_end: t_end )
    allow(RetrieveCustomer).to receive(:call).and_return(stripe_customer)
    allow(stripe_customer).to receive_message_chain(:subscriptions, :first, :id)
    allow(stripe_customer).to receive_message_chain(:subscriptions, :retrieve).and_return(sub)
    allow(sub).to receive(:plan=)
    expect(sub).to receive(:trial_end=).with(t_end.to_i)
    ChangePlan.call(account)
  end

  it "sets the trial end to null if same as now" do
    t_end = Time.now
    sub = double('subscription', save: true, trial_end: t_end )
    allow(RetrieveCustomer).to receive(:call).and_return(stripe_customer)
    allow(stripe_customer).to receive_message_chain(:subscriptions, :first, :id)
    allow(stripe_customer).to receive_message_chain(:subscriptions, :retrieve).and_return(sub)
    allow(sub).to receive(:plan=)
    expect(sub).to receive(:trial_end=).with('now')
    ChangePlan.call(account)
  end

  it "sets the trial end to null if in the past" do
    t_end = Time.now - 1.day
    sub = double('subscription', save: true, trial_end: t_end )
    allow(RetrieveCustomer).to receive(:call).and_return(stripe_customer)
    allow(stripe_customer).to receive_message_chain(:subscriptions, :first, :id)
    allow(stripe_customer).to receive_message_chain(:subscriptions, :retrieve).and_return(sub)
    allow(sub).to receive(:plan=)
    expect(sub).to receive(:trial_end=).with('now')
    ChangePlan.call(account)
  end

  it "sets the trial end to null if null" do
    t_end = nil
    sub = double('subscription', save: true, trial_end: t_end )
    allow(RetrieveCustomer).to receive(:call).and_return(stripe_customer)
    allow(stripe_customer).to receive_message_chain(:subscriptions, :first, :id)
    allow(stripe_customer).to receive_message_chain(:subscriptions, :retrieve).and_return(sub)
    allow(sub).to receive(:plan=)
    expect(sub).to receive(:trial_end=).with('now')
    ChangePlan.call(account)
  end

end