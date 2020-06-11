require 'rails_helper'

describe UpdateCard do

  let(:account){ FactoryBot.create(:account,
    card_last4: "1234",
    state: "trialing"
    ) }


  describe 'call' do

    let(:params){{ token: "xxx", account: account }}
    let(:customer){ double(Stripe::Customer).as_null_object }
    let(:card_dbl) { double(
      'card',
      exp_year: 2020,
      exp_month: 12,
      last4: "4242"
    )}
    before do
      allow(RetrieveCustomer).to receive(:call).and_return(customer)
      allow(customer).to receive_message_chain(:cards, :retrieve).and_return(card_dbl)
    end

    it "No longer updates Stripe customer" do
      expect(customer).not_to receive(:save)
      card = UpdateCard.call(params)
    end

    it "No longer updates the account" do
      expect(account).not_to receive(:update)
      card = UpdateCard.call(params)
    end

    it "returns account if invalid token" do
      allow(customer).to receive(:save).and_raise(Stripe::StripeError)
      card = UpdateCard.call(params)
      expect(card).to eq account
    end

    it "returns account if no customer" do
      allow(RetrieveCustomer).to receive(:call).and_raise(Stripe::StripeError)
      card = UpdateCard.call(params)
      expect(card).to eq account
    end

    it "no longer transitions state to paying from expired" do
      account.update!(state: "expired")
      card = UpdateCard.call(params)
      expect(account.reload.paying?).to be false
    end

    it "it leaves state at trialing" do
      account.update!(state: "trialing")
      card = UpdateCard.call(params)
      expect(account.reload.trialing?).to be true
    end

    it "it leaves state at paid" do
      account.update!(state: "paid")
      allow(RetrieveCustomer).to receive(:call).and_return(customer)
      card = UpdateCard.call(params)
      expect(account.reload.paid?).to be true
    end

  end
end