require 'spec_helper'

describe InvoicesHelper do

  before(:each) do
    @customer = create(:customer)
    @account = create(:account)
    @vat_rate = create(:vat_rate, account_id: @account.id, name: "Standard", rate: "20")
    @vat_rate2 = create(:vat_rate, account_id: @account.id, name: "Reduced", rate: "5")
    @bill = create(:bill, account_id: @account.id, customer_id: @customer.id, amount: "120", vat: "20", vat_rate_id: @vat_rate.id )
    @bill2 = create(:bill, account_id: @account.id, customer_id: @customer.id, amount: "120", vat: "20", vat_rate_id: @vat_rate.id )
    @bill3 = create(:bill, account_id: @account.id, customer_id: @customer.id, amount: "105", vat: "5", vat_rate_id: @vat_rate2.id )
    @invoice = create(:invoice, customer_id: @customer.id, account_id: @account.id)
    @bill.update_attributes(invoice_id: @invoice.id)
    @bill2.update_attributes(invoice_id: @invoice.id)
    @bill3.update_attributes(invoice_id: @invoice.id)
  end

  it "calculates VAT total" do
    expect(total_vat(@invoice)).to eq 45
  end

  it "calculates sums by rate" do
    expect(vat_by_rate(@invoice, @vat_rate)).to eq 40
    expect(vat_by_rate(@invoice, @vat_rate2)).to eq 5
  end

  it "lists vat rates" do
    @bills = @invoice.bills
    expect(vat_rates(@bills)).to eq [@vat_rate, @vat_rate2]
  end
  
end