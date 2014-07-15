require 'spec_helper'
require 'stripe_mock'

describe InvoiceMailer, type: :request do

  after { StripeMock.stop }

  before do
    Stripe.api_key = 'sk_fake_api_key' # to ensure that Stripe.com isn't processing this
    StripeMock.start
    # StripeMock.toggle_debug(true)
    @account = FactoryGirl.create(:account, stripe_customer_token: "cust_token")
    @charge = Stripe::Charge.create( :amount => 400, 
      :currency => "gbp",
       :card => "empty",
       :description => "Charge for test@example.com" )
    @event = StripeMock.mock_webhook_event('invoice.created', {
        :customer => "cust_token",
        :total => 1200,
        :charge => @charge.id
      })
    @invoice = @event.data.object 
    
  end

  describe '#after_invoice_created!' do
    it "responds with success" do
      post 'stripe/events', @event.to_h, {'HTTP_ACCEPT' => "application/json"}
      expect(response.code).to eq '201'
    end

    it "mocks a stripe webhook" do
      expect(@event.id).to_not be_nil
      expect(@invoice.id).to_not be_nil
      expect(@invoice.id).to eq "in_00000000000000"
      expect(@invoice.lines.count).to eq 1
    end

  end

  describe '#new_invoice' do
    before do
      @mail =  InvoiceMailer.new_invoice(@account, @invoice, @charge)
    end

    it "renders the subject" do
      expect(@mail.subject).to eq 'BulldogClip - Your new invoice'
    end

    it "renders the to" do
      expect(@mail.to).to eq [@account.email]
    end

    it "renders the from" do
      expect(@mail.from).to eq ['hello@bulldogclip.co.uk']
    end

    it "sends an email" do
      expect { @mail.deliver }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end
