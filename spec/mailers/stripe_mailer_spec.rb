require 'rails_helper'

describe StripeMailer, type: :mailer do

  describe 'trial_period_ending' do
    let(:sub){ double 'subscription', trial_end: 1381021530 }
    let(:account){ double 'Account', email: 'cust@example.com'}
    let(:mail){StripeMailer.trial_period_ending(sub, account)}

    it "sends a trial period ending email" do
      expect(mail.subject).to eq "Your trial period is coming to an end"
      expect(mail.to).to eq ['cust@example.com']
      expect(mail.from).to eq ["info@bulldogclip.co.uk"]
      expect(mail.body).to include("free trial period ends on 06 October 2013")
    end
  end
end
