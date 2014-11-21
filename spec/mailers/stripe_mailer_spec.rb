require 'rails_helper'
require 'stripe_mock'

describe StripeMailer, type: :mailer do

  let(:account){ double 'Account', email: 'cust@example.com'}

  describe 'trial_period_ending' do
    let(:sub){ double 'subscription', trial_end: 1381021530 }
    let(:mail){StripeMailer.trial_period_ending(sub, account)}

    it "sends a trial period ending email" do
      expect(mail.subject).to eq "Your trial period is coming to an end"
      expect(mail.to).to eq ['cust@example.com']
      expect(mail.from).to eq ["info@bulldogclip.co.uk"]
      expect(mail).to have_body_text("free trial period ends on 06 October 2013")
    end

    it "delivers an email" do
      mail.deliver
      expect{mail.deliver}.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end

  describe 'new_invoice' do
    let(:invoice){ double 'Invoice',
      date: Time.now,
      id: "inv_123",
      total: 5000,
      starting_balance: 0,
      ending_balance: 0,
      amount_due: 5000,
      lines: lines }
    let(:lines){ [OpenStruct.new(description: "Plan subscription", amount: 50000)]}
    let(:card){ "NA" }
    let(:mail){StripeMailer.new_invoice(account, invoice, card)}

    it "sends a new invoice email" do
      expect(mail.subject).to eq 'BulldogClip - Your new invoice'
      expect(mail.to).to eq ['cust@example.com']
      expect(mail).to be_delivered_from('BulldogClip<noreply@bulldogclip.co.uk>')
      expect(mail).to have_body_text("BulldogClip Subscription Invoice")
      expect(mail).to have_body_text("inv_123")
      expect(mail).to have_body_text("£50.00")
      expect(mail).to have_body_text("Plan subscription")
      expect(mail).to have_body_text("NA")
    end
  end

  describe 'error_invoice' do
    let(:invoice){ double 'Invoice',
      date: 1405670902,
      id: "inv_123",
      customer: "cust",
      livemode: false }
    let(:status){"active"}
    let(:event){ double 'Event', type: "invoice.payment_succeeded"}
    let(:mail){StripeMailer.error_invoice(invoice, event, status)}

    it "sends an error invoice" do
      expect(mail.subject).to eq 'Invoice error'
      expect(mail.to).to eq ['info@bulldogclip.co.uk']
      expect(mail).to be_delivered_from("BulldogClip <info@bulldogclip.co.uk>")
      expect(mail).to have_body_text("invoice.payment_succeeded event")
      expect(mail).to have_body_text("inv_123")
      expect(mail).to have_body_text("Invoice Date: 18 July 2014")
      expect(mail).to have_body_text("Subscription status: active")
      expect(mail).to have_body_text("Livemode: false")
    end
  end

  describe "charge failed email" do
    let(:event){ double 'Event', type: "charge.failed"}
    let(:card){ double 'card',
      brand:          "Visa",
      last4:          "1234",
      exp_month:      12,
      exp_year:       2015
    }
    let(:charge){ double 'Charge',
      livemode:         false,
      id:               "chg_id",
      customer:         "cust",
      failure_code:     "A",
      failure_message:  "it failed",
      card: card
    }
    let(:mail){StripeMailer.charge_failed(charge, event)}

    it "sends an email" do
      expect(mail.subject).to eq 'Charge failed'
      expect(mail.to).to eq ['info@bulldogclip.co.uk']
      expect(mail).to be_delivered_from("BulldogClip <info@bulldogclip.co.uk>")
      expect(mail).to have_body_text("charge.failed event")
      expect(mail).to have_body_text("Charge: chg_id")
      expect(mail).to have_body_text("last 4 1234")
      expect(mail).to have_body_text("exp month 12")
      expect(mail).to have_body_text("Livemode: false")
    end
  end
end
