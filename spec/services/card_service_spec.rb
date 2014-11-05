require 'rails_helper'

describe CardService do

  let(:customer){ double(id: "cus_12345") }

  describe 'create_customer' do
    it "returns a customer" do
      params = {
        email: "test@example.com"
      }

      expect(Stripe::Customer).to receive(:create).and_return(:customer)
      customer = CardService.new(params).create_customer
    end
    it "returns false if there is an error" do
      params = {
        email: "test@example.com"
      }

      allow(Stripe::Customer).to receive(:create).and_raise(Stripe::StripeError)
      customer = CardService.new(params).create_customer
      expect(customer).to eq false
    end
  end

  describe 'get_customer' do
    it 'returns a customer' do
      params = {
        customer_id: "cus_12345"
      }
      expect(Stripe::Customer).to receive(:retrieve).and_return(:customer)
      customer = CardService.new(params).get_customer
    end
    it 'returns false when no customer' do
      params = {
        customer_id: "cus_12345"
      }
      allow(Stripe::Customer).to receive(:retrieve).and_raise(Stripe::StripeError)
      customer = CardService.new(params).get_customer
      expect(customer).to eq false
    end
  end

  describe 'create_subscription' do
    let(:subscription){ double("subscription") }
    # let(:get_customer){ double('customer') }

    params = {
        customer_id: "cus_12345",
        plan_id: "1"
      }

    it "gets a customer" do
      expect(Stripe::Customer).to receive(:retrieve).and_return(customer)
      allow(customer).to receive_message_chain(:subscriptions, :create)
      sub = CardService.new(params).create_subscription
    end


    it "returns a subscription" do
      # allow(CardService).to receive(:get_customer).and_return(customer)
      allow(Stripe::Customer).to receive(:retrieve).and_return(customer)
      allow(customer).to receive_message_chain(:subscriptions, :create).
        and_return(subscription)
      sub = CardService.new(params).create_subscription
      expect(sub).to eq subscription
    end

    it "returns false with invalid customer_id" do
      allow(Stripe::Customer).to receive(:retrieve).and_raise(Stripe::StripeError)
      # allow(customer).to receive_message_chain(:subscriptions, :create).and_return(subscription)
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

    params = {
      token: 'xxx',
      customer_id: "cus_12345",
      account: FactoryGirl.create(:account)
    }

    it "updates Stripe customer" do
      allow(Stripe::Customer).to receive(:retrieve).and_return(customer)
      allow(customer).to receive(:card=)
      expect(customer).to receive(:save)
      card = CardService.new(params).update_card
    end
    it "returns false if invalid token" do
      allow(Stripe::Customer).to receive(:retrieve).and_return(customer)
      allow(customer).to receive(:card=)
      allow(customer).to receive(:save)#.and_raise(Stripe::CardError)
      card = CardService.new(params).update_card
      expect(card).to eq false
    end
  end
end