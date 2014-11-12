require 'rails_helper'
require 'stripe_mock'

# Use type of request to allow post method for webhook testing

describe ProcessStripeWebhooks, type: :request do

  before do
    Stripe.api_key = 'sk_fake_api_key'
    StripeMock.start
  end
  after { StripeMock.stop }

  describe 'after customer subscription trial will end' do

    let(:account){
      double('Account',
      stripe_customer_token: "cust_token",
      email: "cust@example.com"
      )}

    let(:event){
      StripeMock.mock_webhook_event('customer.subscription.trial_will_end',
        {customer: "cust_token", trail_end: 1415308994 }
      )
    }

    it "sends an email to the account holder" do
      allow(Account).to receive(:find_by_stripe_customer_token).and_return(account)
      # expect(StripeMailer).to receive_message_chain(:trial_period_ending, :deliver)
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
      # open_email('cust@example.com', with_subject: "Your trial period is coming to an end")
    end
  end

  describe '#after_invoice_payment_succeeded!' do
    let(:stripe_customer){
      Stripe::Customer.create(
        email: "cust@example.com"
        )
    }
    let(:errors){ {base: []}}
    let(:account){
      double('Account',
        id: 1,
        stripe_customer_token: stripe_customer.id,
        email: "cust@example.com",
        plan_id: 1,
        errors: errors
      )
    }

    let(:charge){
      Stripe::Charge.create(
        card: card.id,
        amount: 400,
        currency: "gbp",
        description: "Charge for test",
        balance_transaction: ""
      )
    }

    let(:balance){ double('balance', fee: 44) }

    let(:card){
      stripe_customer.cards.create(
        number: "4242424242424242",
        exp_year: 2020,
        exp_month: 12,
        cvc: 321
      )
    }

    let(:event){
      StripeMock.mock_webhook_event('invoice.payment_succeeded', {
        customer: stripe_customer.id,
        charge:   charge})}

    before do
      allow(Account).to receive(:find_by_stripe_customer_token).and_return(account)
      allow(ProcessStripeWebhooks).to receive(:subscription_status).and_return("active")
      allow(ProcessStripeWebhooks).to receive(:card_detail).and_return("card detail")
      allow(Stripe::Charge).to receive(:retrieve).and_return(charge)
      allow(Stripe::BalanceTransaction).to receive(:retrieve).and_return(balance)
    end

    it "copes with null charge" do
      allow(Stripe::Charge).to receive(:retrieve).and_return(nil)
      allow(ProcessStripeWebhooks).to receive(:subscription_status).and_return("active")
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
      expect(response.code).to eq '201'
    end

    it "responds with success" do
      allow(ProcessStripeWebhooks).to receive(:subscription_status).and_return("active")
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
      expect(response.code).to eq '201'
    end

    it "sends a new invoice email" do
      expect(StripeMailer).to receive_message_chain(:new_invoice, :deliver)
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
    end

    it "creates a sale record" do
      expect(Sale).to receive(:create)
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
    end

    it "creates a sale even when nil charge" do
      allow(Stripe::Charge).to receive(:retrieve).and_return(nil)
      expect(Sale).to receive(:create)
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
    end

    it "updates the account next invoice date" do
      allow(Stripe::Invoice).to receive_message_chain(:upcoming, :date).and_return(1381021530)
      date = Time.at(1381021530)
      expect(account).to receive(:update).with({ next_invoice: date })
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
    end

    it "sends an error email if there is an error" do
      error_event = StripeMock.mock_webhook_event('invoice.payment_succeeded', {
        :customer => "missing",
        :total => 1200,
        :charge => ""
      })
      allow(Account).to receive(:find_by_stripe_customer_token)
      expect(StripeMailer).to receive_message_chain(:error_invoice, :deliver)
      post 'stripe/events', error_event.to_h, {'HTTP_ACCEPT' => "application/json"}
    end

    it "does not send if status is 'trialing'" do
      allow(ProcessStripeWebhooks).to receive(:subscription_status).and_return("trialing")
      expect(StripeMailer).to_not receive(:new_invoice)
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
    end

    it "does send if status is 'trialing' but value > 0" do
      allow(ProcessStripeWebhooks).to receive(:subscription_status).and_return("trialing amount due 10")
      expect(StripeMailer).to receive_message_chain(:new_invoice, :deliver)
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
    end
  end

  describe "#update_account" do
    let(:account){double 'Account'}
    let(:invoice){double 'Invoice', customer: "cust_token"}

    it "stores a date" do
      allow(Stripe::Invoice).to receive_message_chain(:upcoming, :date).and_return(1405670902)
      date = Time.at(1405670902)
      expect(account).to receive(:update).with({next_invoice: date})
      ProcessStripeWebhooks.update_account_next_invoice(account, invoice)
    end

    it "tolerates a missing date" do
      allow(Stripe::Invoice).to receive_message_chain(:upcoming, :date)
      # date = Time.at(1405670902)
      expect(account).to_not receive(:update)#.with({next_invoice: nil})
      ProcessStripeWebhooks.update_account_next_invoice(account, invoice)
    end
  end

  describe "subscription_status" do
    let(:customer){Stripe::Customer.create(id: "cust_token")}
    let(:invoice) {double('invoice',
      customer: "cust_token",
      amount_due: 0)}
    it "returns a string" do
      status = ProcessStripeWebhooks.subscription_status(invoice)
      expect(status).to be_a(String)
    end
    it "returns a unknown if stripe error" do
      status = ProcessStripeWebhooks.subscription_status(invoice)
      expect(status).to eq("unknown")
    end
    it "returns trialing if trialing" do
      allow(Stripe::Customer).to receive(:retrieve).and_return(customer)
      allow(customer).
        to receive_message_chain(:subscriptions, :first, :status).
        and_return("trialing")
      status = ProcessStripeWebhooks.subscription_status(invoice)
      expect(status).to eq("trialing")
    end
    it "returns amount due if not zero" do
      allow(Stripe::Customer).to receive(:retrieve).and_return(customer)
      allow(customer).
        to receive_message_chain(:subscriptions, :first, :status).
        and_return("trialing")
      allow(invoice).to receive(:amount_due).and_return(10)
      status = ProcessStripeWebhooks.subscription_status(invoice)
      expect(status).to eq("trialing amount_due 10")
    end
  end

  describe "card_detail" do

    it "retrieves the charge if present" do
      card = double('card', type: 'visa', last4: '4567')
      charge = double('charge', card: card)
      invoice = double('invoice', charge: "not null")
      allow(Stripe::Charge).to receive(:retrieve).and_return(charge)
      card = ProcessStripeWebhooks.card_detail(invoice)
      expect(card).to eq "visa ending in 4567"
    end

    it "returns NA if no charge" do
      card = double('card', type: 'visa', last4: '4567')
      charge = double('charge', card: card)
      invoice = double('invoice', charge: "null")
      allow(Stripe::Charge).to receive(:retrieve).and_return(charge)
      card = ProcessStripeWebhooks.card_detail(invoice)
      expect(card).to eq "NA"
    end

    it "returns NA if Stripe error" do
      card = double('card', type: 'visa', last4: '4567')
      charge = double('charge', card: card)
      invoice = double('invoice', charge: "not null")
      # allow(Stripe::Charge).to receive(:retrieve).and_raise(Stripe::InvalidRequestError)
      card = ProcessStripeWebhooks.card_detail(invoice)
      expect(card).to eq "NA"
    end
  end

  describe "after charge succeeded" do
    let(:account){
      double('Account',
      stripe_customer_token: "cust_token",
      email: "cust@example.com")}

    let(:event){
      StripeMock.mock_webhook_event('charge.succeeded', {
        customer: "cust_token"
        })}

    before do
      allow(account).to receive(:charge!)
      allow(Account).to receive(:find_by_stripe_customer_token).and_return(account)
    end

    it "responds with success" do
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
      expect(response.code).to eq '201'
    end

    it "updates account state" do
      expect(account).to receive(:charge!)
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
    end
  end
end