require 'rails_helper'

describe CancelSale do
  
  let(:account){ double(
      plan_id: 1,
      id: 1,
      stripe_customer_token: "cust",
      email: "test@example.com"
      ).as_null_object
    }
  let(:cancel_sale){ CancelSale.new(account) }

  describe "process" do
    it "sends cancel message to sale" do
      expect_any_instance_of(Sale).to receive(:cancel!)
      cancel_sale.process
    end

    it "returns false if sale errors" do
      allow_any_instance_of(Sale).to receive(:cancel!)
      allow_any_instance_of(Sale).to receive(:errored?).and_return(true)
      allow_any_instance_of(Sale).to receive(:finished?).and_return(false)
      cancel_sale.process
      expect(cancel_sale.process).to be_falsey
    end
    it "returns true if sale finished" do
      allow_any_instance_of(Sale).to receive(:cancel!)
      allow_any_instance_of(Sale).to receive(:errored?).and_return(false)
      allow_any_instance_of(Sale).to receive(:finished?).and_return(true)
      expect(cancel_sale.process).to be_truthy
    end
    it "sets account next invoice to null" do
      allow_any_instance_of(Sale).to receive(:cancel!)
      allow_any_instance_of(Sale).to receive(:finished?).and_return(true)
      expect(account).to receive(:next_invoice=).with(nil)
      cancel_sale.process
    end
  end
end