require 'rails_helper'

describe UpdateCard do

  let(:account){ FactoryGirl.create(:account, card_last4: "1234") }


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
      allow_any_instance_of(UpdateCard).to receive(:get_customer).and_return(stripe_dbl)
      expect(stripe_dbl).to receive(:save)
      card = UpdateCard.call(params)
    end

    it "updates the account" do
      allow_any_instance_of(UpdateCard).to receive(:get_customer).and_return(stripe_dbl)
      expect(account).to receive(:update)
      card = UpdateCard.call(params)
      # expect(account.card_last4).to eq("4242".to_i)
    end

    it "returns false if invalid token" do
      allow_any_instance_of(UpdateCard).to receive(:get_customer).and_return(stripe_dbl)
      allow(stripe_dbl).to receive(:save).and_raise(Stripe::StripeError)
      card = UpdateCard.call(params)
      expect(card).to eq false
    end

    it "returns false if no customer" do
      allow_any_instance_of(UpdateCard).to receive(:get_customer).and_return(false)
      card = UpdateCard.call(params)
      expect(card).to eq false
    end
  end
end