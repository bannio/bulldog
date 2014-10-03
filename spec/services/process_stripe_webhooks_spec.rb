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
      )
    }

    let(:event){
      StripeMock.mock_webhook_event('customer.subscription.trial_will_end', {
        :customer => "cust_token"
      })
    }

    it "sends an email to the account holder" do
      allow(Account).to receive(:find_by_stripe_customer_token).and_return(account)
      expect(StripeMailer).to receive_message_chain(:trial_period_ending, :deliver)
      post 'stripe/events', event.to_h, {'HTTP_ACCEPT' => "application/json"}
      # open_email('cust@example.com', with_subject: "Your trial period is coming to an end")
    end
  end

end