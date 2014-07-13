require 'spec_helper'
require 'stripe_mock'

describe InvoiceMailer, type: :request do

  after { StripeMock.stop }

  before do
    Stripe.api_key = 'sk_fake_api_key' # to ensure that Stripe.com isn't processing this
    StripeMock.start
    # StripeMock.toggle_debug(true)
    @user = FactoryGirl.create(:user)
    @account = FactoryGirl.create(:account, user_id: @user.id, stripe_customer_token: "cust_token")
    @event = StripeMock.mock_webhook_event('invoice.created', {
        :customer => "cust_token",
        :total => 1200
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

  # it "should process an event" do
  #   evt = StripeMock.mock_webhook_event('invoice.created')

  #   dup = Stripe::Event.retrieve(evt.id)

  #   expect(dup.data.object.lines.count).to eq evt.data.object.lines.count
  # end

  describe '#new_invoice' do
    before do
      @mail =  InvoiceMailer.new_invoice(@user, @invoice)
    end

    it "renders the subject" do
      expect(@mail.subject).to eq 'BulldogClip - Your new invoice'
    end

    it "renders the to" do
      expect(@mail.to).to eq [@user.email]
    end

    it "renders the from" do
      expect(@mail.from).to eq ['hello@bulldogclip.co.uk']
    end

    it "sends an email" do
      expect { @mail.deliver }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end