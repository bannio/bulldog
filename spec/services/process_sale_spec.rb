require 'rails_helper'
# require 'stripe_mock'

describe ProcessSale do

  let(:account){ double(
      plan_id: 1,
      id: 1,
      stripe_customer_token: "cust",
      email: "test@example.com"
      ).as_null_object
    }
  let(:process_sale){ ProcessSale.new(account) }

  describe "process" do
    it "sends process message to sale" do
      expect_any_instance_of(Sale).to receive(:process!)
      process_sale.process
    end

    it "returns false if sale errors" do
      allow_any_instance_of(Sale).to receive(:process!)
      allow_any_instance_of(Sale).to receive(:errored?).and_return(true)
      expect(process_sale.process).to be_falsey
    end
    it "returns true if sale finished" do
      allow_any_instance_of(Sale).to receive(:process!)
      allow_any_instance_of(Sale).to receive(:errored?).and_return(false)
      allow_any_instance_of(Sale).to receive(:finished?).and_return(true)
      expect(process_sale.process).to be_truthy
    end
  end

  describe "transfer_details_to_account" do
    let(:sale){ double(
      card_last4:      1234,
      card_expiration: 1.year.from_now.to_s(:db),
      next_invoice:    1.month.from_now.to_s(:db),
      plan_id:         1
      ) }
    let(:account){ Account.new }

    it "updates the account details" do
      process_sale.transfer_details_to_account(sale)
      expect(account.card_last4).to eq(1234)
      expect(account.card_expiration).to eq(1.year.from_now.to_date)
      expect(account.next_invoice).to eq(1.month.from_now.to_date)
      expect(account.vat_enabled).to be_falsey
    end
  end

end