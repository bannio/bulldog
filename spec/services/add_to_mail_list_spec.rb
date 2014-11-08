require 'rails_helper'

describe AddToMailList do

  let(:mailchimp){ double('mailchimp').as_null_object }
  let(:email){ "test@example.com" }

  it "calls MailChimp" do
    allow(Mailchimp::API).to receive(:new).and_return(mailchimp)
    expect(mailchimp).to receive_message_chain(:lists, :subscribe)
    AddToMailList.call(email)
  end
end