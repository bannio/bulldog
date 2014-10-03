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
      StripeMock.mock_webhook_event('customer.subscription.trial_will_end', {
        :customer => "cust_token"}
      )
    }

    it "sends an email to the account holder" do
      allow(Account).to receive(:find_by_stripe_customer_token).and_return(account)
      expect(StripeMailer).to receive_message_chain(:trial_period_ending, :deliver)
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
      # open_email('cust@example.com', with_subject: "Your trial period is coming to an end")
    end
  end

  describe '#after_invoice_payment_succeeded!' do
    let(:account){
      double('Account',
      stripe_customer_token: "cust_token",
      email: "cust@example.com")}

    let(:event){
      StripeMock.mock_webhook_event('invoice.payment_succeeded', {
        customer: "cust_token",
        charge:   "null"})}

    it "responds with success" do
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
      expect(response.code).to eq '201'
    end

    it "sends a new invoice email" do
      allow(Account).to receive(:find_by_stripe_customer_token).and_return(account)
      expect(StripeMailer).to receive_message_chain(:new_invoice, :deliver)
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
    end

    it "updates the account next invoice date" do
      allow(Account).to receive(:find_by_stripe_customer_token).and_return(account)
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
      expect(StripeMailer).to receive_message_chain(:error_invoice, :deliver)
      post 'stripe/events', error_event.to_h, {'HTTP_ACCEPT' => "application/json"}
      # open_email('info@bulldogclip.co.uk', with_text: 'Invoice Webhook Error')
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
end