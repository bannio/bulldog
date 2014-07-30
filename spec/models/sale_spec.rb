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
          # name: 'test_name',
          plan_id: 'test_plan',
          account_id: @account.id 
          )
      end

      it "transitions to finished if successful" do
        customer = double
        subscription = double
        allow(Stripe::Customer).to receive(:retrieve).with(anything).and_return(customer)
        allow(customer).to receive(:subscriptions => [subscription])
        allow([subscription]).to receive(:total_count).and_return(0)
        allow([subscription]).to receive(:create)
        # allow(customer).to receive_message_chain(:subscriptions, :total_count => true)
        # allow(customer).to receive_message_chain(:subscriptions, :create => subscription)

        @sale.process!
        expect(@sale.finished?).to be_truthy
      end

      it "retrieves the stripe customer" do
        expect(Stripe::Customer).to receive(:retrieve).with('customer_token').and_return(@customer)
        @sale.process!

      end

      it "creates a subscription if new" do
        customer = double
        allow(customer).to receive_message_chain(:subscriptions, :total_count => 0)
        sale = Sale.create(
          email: 'test2.sale@example.com',
          stripe_customer_id: 'customer2_token',
          # name: 'test_name',
          plan_id: 'test_plan',
          account_id: @account.id 
          )
        sale.process!
        expect(@customer.subscriptions.list).to_not be_empty
      end

      it "updates subscription if exists" do
        
      end
    end
  end

end
