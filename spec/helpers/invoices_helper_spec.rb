require 'rails_helper'

describe InvoicesHelper do

  before(:each) do
    @customer = create(:customer)
    allow_any_instance_of(Account).to receive(:get_customer).and_return(true)
    allow_any_instance_of(Account).to receive(:process_sale).and_return(true)
    @account = create(:account)
    # @setting = create(:setting, account_id: @account.id)
    @vat_rate = create(:vat_rate, account_id: @account.id, name: "Standard", rate: "20")
    @vat_rate2 = create(:vat_rate, account_id: @account.id, name: "Reduced", rate: "5")
    @bill = create(:bill, account_id: @account.id, customer_id: @customer.id, amount: "120", vat: "20", vat_rate_id: @vat_rate.id )
    @bill2 = create(:bill, account_id: @account.id, customer_id: @customer.id, amount: "120", vat: "20", vat_rate_id: @vat_rate.id )
    @bill3 = create(:bill, account_id: @account.id, customer_id: @customer.id, amount: "105", vat: "5", vat_rate_id: @vat_rate2.id )
    @bill4 = create(:bill, account_id: @account.id, customer_id: @customer.id, amount: "105", vat: "5", vat_rate_id: @vat_rate2.id )
    @bill5 = create(:bill, account_id: @account.id, customer_id: @customer.id, amount: "120", vat: "20", vat_rate_id: @vat_rate.id )
    @invoice = create(:invoice, customer_id: @customer.id, account_id: @account.id)
    @bill.update_attributes(invoice_id: @invoice.id)
    @bill2.update_attributes(invoice_id: @invoice.id)
    @bill3.update_attributes(invoice_id: @invoice.id)
    @bill4.update_attributes(invoice_id: @invoice.id)
    @bill5.update_attributes(invoice_id: @invoice.id)
  end

  it "calculates VAT total" do
    expect(helper.total_vat(@invoice)).to eq 70
  end

  it "calculates sums by rate" do
    expect(helper.vat_by_rate(@invoice, @vat_rate)).to eq 60
    expect(helper.vat_by_rate(@invoice, @vat_rate2)).to eq 10
  end

  it "lists vat rates" do
    # expect an array of vat rate objects
    @bills = @invoice.bills
    expect(helper.vat_rates(@bills)).to eq [@vat_rate, @vat_rate2]
  end

  it "returns nil or a valid logo file name" do
    expect(logo_file(@invoice)).to eq nil
    @invoice.account.setting.update_attribute(:logo_file_name, "myLogo")
    expect(logo_file(@invoice)).to include "/medium/myLogo"
  end

  it "responds to current_card" do
    account = Account.new(card_last4: 1234)
    expect(current_card(account)).to eq 1234
  end

  it "responds to current_card with NA when empty" do
    account = Account.new()
    expect(current_card(account)).to eq "NA"
  end

  it "responds to next_invoice_date" do
    account = Account.new(next_invoice: "2014-10-25".to_date)
    expect(next_invoice_date(account)).to eq "25/10/2014"
  end

  it "responds to next_invoice_date with NA when empty" do
    account = Account.new()
    expect(next_invoice_date(account)).to eq "NA"
  end
  
end