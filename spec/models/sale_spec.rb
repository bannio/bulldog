require 'rails_helper'
require 'stripe_mock'

describe Sale do

  before { StripeMock.start }
  # before { StripeMock.toggle_debug(true) }
  after { StripeMock.stop }

  before do
    Stripe.api_key = 'sk_fake_api_key' # to ensure that Stripe.com isn't processing this
    @customer = Stripe::Customer.create({
      id:    'customer_token',
      email: 'test.sale@example.com',
      card: 'void_card_token'
    })
    @plan = Stripe::Plan.create({
      id: 'test_plan'
      })
    @account = Account.create(
      name: 'Sale Test',
      email: 'test.sale@example.com'
      )
  end

  describe "process" do
    context "successfully" do
      before do
        @sale = Sale.create(
          email: 'test.sale@example.com',
          stripe_customer_id: 'customer_token',
          plan_id: 1,
          account_id: @account.id 
          )
      end

      it "transitions to finished" do
        Stripe::Plan.create({id: '1'})
        # current version of stripe-ruby-mock does not support total_count
        allow_any_instance_of(Stripe::ListObject).to receive(:total_count).and_return(0)
        @sale.process!
        expect(@sale.finished?).to be_truthy
      end

      it "retrieves the stripe customer" do
        Stripe::Plan.create({id: '1'})
        allow_any_instance_of(Stripe::ListObject).to receive(:total_count).and_return(0)
        expect(Stripe::Customer).to receive(:retrieve).with('customer_token').and_return(@customer)
        @sale.process!

      end

      it "creates a subscription if new" do
        Stripe::Plan.create({id: '1'})
        allow_any_instance_of(Stripe::ListObject).to receive(:total_count).and_return(0)
        expect_any_instance_of(Stripe::ListObject).to receive(:create).with({plan: '1'})
        @sale.process!
      end

      it "updates subscription if exists" do
        Stripe::Plan.create({id: '1'})
        @customer.subscriptions.create({plan: '1'})
        # allow_any_instance_of(Stripe::ListObject).to receive(:total_count).and_return(1)
        expect_any_instance_of(Stripe::Subscription).to receive(:save)
        @sale.process!
      end

      it "stores the card details" do
        Stripe::Plan.create({id: '1'})
        allow_any_instance_of(Stripe::ListObject).to receive(:total_count).and_return(0)
        @sale.process!
        expect(@sale.card_last4).to eq '4242'
        expect(@sale.card_expiration).to eq Date.new(2016,4,1)
      end
    end
    context "unsuccessfully" do
      before do
        @sale = Sale.create(
          email: 'test.sale@example.com',
          stripe_customer_id: 'missing_customer',
          plan_id: 1,
          account_id: @account.id 
          )
      end
      it "saves with an errored state" do
        @sale.process!
        expect(@sale.errored?).to be_truthy
        expect(@sale.error).to include('No such customer: missing_customer')
      end
      it "can handle a missing customer" do
        @sale.process!
        expect(@sale.errored?).to be_truthy
      end
      it "can handle a missing subscription" do
        error = Stripe::InvalidRequestError.new('does not have a subscription with ID','test')
        subscription = double
        allow(Stripe::Customer).to receive(:retrieve).with('missing_customer').and_return(@customer)
        allow(@customer).to receive_message_chain(:subscriptions, :total_count).and_return(1)
        allow(@customer).to receive_message_chain(:subscriptions, :first, :id).and_return('test')
        allow(@customer).to receive_message_chain(:subscriptions, :retrieve).with('test').and_raise(error)
        @sale.process!
        expect(@sale.error).to include('does not have a subscription with ID')
      end
    end
  end

end
