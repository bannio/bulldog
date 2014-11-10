require 'rails_helper'

describe UpdateCard do

  let(:account){ FactoryGirl.create(:account,
    card_last4: "1234",
    state: "trialing"
    ) }


  describe 'call' do

    let(:params){{ token: "xxx", account: account }}
    let(:stripe_dbl){ double(Stripe::Customer).as_null_object }
    let(:card_dbl) { double(
      'card',
      exp_year: 2020,
      exp_month: 12,
      last4: "4242"
    )}
    before do
      allow_any_instance_of(UpdateCard).
      to receive(:stripe_customer_card).
      and_return(card_dbl)
    end

    it "updates Stripe customer" do
      allow(RetrieveCustomer).to receive(:call).and_return(stripe_dbl)
      expect(stripe_dbl).to receive(:save)
      card = UpdateCard.call(params)
    end

    it "updates the account" do
      allow(RetrieveCustomer).to receive(:call).and_return(stripe_dbl)
      expect(account).to receive(:update)
      card = UpdateCard.call(params)
      # expect(account.card_last4).to eq("4242".to_i)
    end

    it "returns false if invalid token" do
      allow(RetrieveCustomer).to receive(:call).and_return(stripe_dbl)
      allow(stripe_dbl).to receive(:save).and_raise(Stripe::StripeError)
      card = UpdateCard.call(params)
      expect(card).to eq false
    end

    it "returns false if no customer" do
      allow(RetrieveCustomer).to receive(:call).and_return(false)
      card = UpdateCard.call(params)
      expect(card).to eq false
    end

    it "transitions state to paying from expired" do
      account.update!(state: "expired")
      allow(RetrieveCustomer).to receive(:call).and_return(stripe_dbl)
      card = UpdateCard.call(params)
      expect(account.reload.paying?).to be true
    end

    it "it leaves state at trialing" do
      account.update!(state: "trialing")
      allow(RetrieveCustomer).to receive(:call).and_return(stripe_dbl)
      card = UpdateCard.call(params)
      expect(account.reload.trialing?).to be true
    end

    it "it leaves state at paid" do
      account.update!(state: "paid")
      allow(RetrieveCustomer).to receive(:call).and_return(stripe_dbl)
      card = UpdateCard.call(params)
      expect(account.reload.paid?).to be true
    end

  end
end