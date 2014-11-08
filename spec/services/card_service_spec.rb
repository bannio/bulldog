require 'rails_helper'

describe CardService do

  let(:account){ FactoryGirl.create(:account) }

  describe 'create_customer' do
    let(:params){{
      email: "test@example.com",
      account: account
    }}

    it "returns a customer" do
      expect(Stripe::Customer).to receive(:create).and_return(:customer)
      customer = CardService.new(params).create_customer
    end

    it "returns false if there is a Stripe error" do
      allow(Stripe::Customer).to receive(:create).and_raise(Stripe::StripeError)
      customer = CardService.new(params).create_customer
      expect(customer).to eq false
    end

  end

  describe 'create_subscription' do
    let(:customer){ double(id: "cus_12345") }
    let(:subscription){ double("subscription") }
    let(:params){{
          customer_id: "cus_12345",
          plan_id: "1",
          account: account
        }}

    it "gets a customer" do
      expect(Stripe::Customer).to receive(:retrieve).and_return(customer)
      allow(customer).to receive_message_chain(:subscriptions, :create)
      sub = CardService.new(params).create_subscription
    end

    it "returns a subscription" do
      allow(Stripe::Customer).to receive(:retrieve).and_return(customer)
      allow(customer).to receive_message_chain(:subscriptions, :create).
        and_return(subscription)
      sub = CardService.new(params).create_subscription
      expect(sub).to eq subscription
    end

    it "returns false with invalid customer_id" do
      allow_any_instance_of(CardService).to receive(:get_customer).and_return(false)
      sub = CardService.new(params).create_subscription
      expect(sub).to eq false
    end

    it "returns false with invalid plan_id" do
      allow(Stripe::Customer).to receive(:retrieve).and_return(customer)
      allow(customer).to receive_message_chain(:subscriptions, :create).
        and_raise(Stripe::StripeError)
      sub = CardService.new(params).create_subscription
      expect(sub).to eq false
    end
  end

  describe 'update_card' do

    let(:params){{
      customer_id: "cus_12345",
      token: "xxx",
      account: account
    }}
    let(:stripe_dbl){ double(Stripe::Customer).as_null_object }
    let(:card_dbl) { double(
      'card',
      exp_year: 2020,
      exp_month: 12,
      last4: "4242"
    )}
    before do
      allow_any_instance_of(CardService).
      to receive(:stripe_customer_card).
      and_return(card_dbl)
    end

    it "updates Stripe customer" do
      allow_any_instance_of(CardService).to receive(:get_customer).and_return(stripe_dbl)
      expect(stripe_dbl).to receive(:save)
      card = CardService.new(params).update_card
    end

    it "updates the account" do
      allow_any_instance_of(CardService).to receive(:get_customer).and_return(stripe_dbl)
      # expect(stripe_dbl).to receive(:save)
      expect(account).to receive(:update)
      card = CardService.new(params).update_card
    end

    it "returns false if invalid token" do
      allow_any_instance_of(CardService).to receive(:get_customer).and_return(stripe_dbl)
      allow(stripe_dbl).to receive(:save).and_raise(Stripe::StripeError)
      card = CardService.new(params).update_card
      expect(card).to eq false
    end

    it "returns false if no customer" do
      allow_any_instance_of(CardService).to receive(:get_customer).and_return(false)
      card = CardService.new(params).update_card
      expect(card).to eq false
    end
  end
end