require 'rails_helper'

describe UpdateAccount do
  # responsible for working out which other objects are required
  # and updating the account

  context ".call" do

    let(:account){ double 'Account',
      plan_id_changed?: true,
      plan_id: 1,
      save: true
    }

    before { allow(account).to receive_message_chain(:errors, :empty?) }

    # it "processes a sale if the plan_id has changed" do
    #   allow(account).to receive(:email_changed?)
    #   expect(ProcessSale).to receive_message_chain(:new, :process)
    #   UpdateAccount.call(account)
    # end

    it "changes a plan if plan changed" do
      allow(account).to receive(:email_changed?)
      expect(ChangePlan).to receive(:call)
      UpdateAccount.call(account)
    end

    it "processes a cancellation if the plan_id has changed to zero" do
      allow(account).to receive(:plan_id).and_return(0)
      allow(account).to receive(:email_changed?)
      expect(CancelSubscription).to receive(:call)
      UpdateAccount.call(account)
    end

    it "updates the Stripe customer email if the email has changed" do
      allow(account).to receive(:plan_id_changed?).and_return(false)
      allow(account).to receive(:email_changed?).and_return(true)
      expect(ChangeStripeEmail).to receive(:call)
      UpdateAccount.call(account)
    end

    it "does not update the email if the email has not changed" do
      allow(account).to receive(:plan_id_changed?).and_return(false)
      allow(account).to receive(:email_changed?).and_return(false)
      expect(ChangeStripeEmail).not_to receive(:call)
      UpdateAccount.call(account)
    end

    it "returns false if there are any errors" do
      allow(account).to receive(:email_changed?).and_return(false)
      allow(ChangePlan).to receive(:call)
      allow(account).to receive_message_chain(:errors, :empty?).and_return(false)
      expect(UpdateAccount.call(account)).to be_falsey
    end

    it "saves an updated account if there are no errors" do
      allow(account).to receive(:email_changed?).and_return(false)
      allow(account).to receive(:plan_id_changed?).and_return(false)
      allow(account).to receive_message_chain(:errors, :empty?).and_return(true)
      expect(account).to receive(:save)
      UpdateAccount.call(account)
    end

    it "updates other attributes e.g. name" do
      new_name_account = FactoryGirl.create(:account)
      new_name_account.name = "my new name"
      UpdateAccount.call(new_name_account)
      expect(new_name_account.reload.name).to eq("my new name")
    end

  end
end