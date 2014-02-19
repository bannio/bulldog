require 'spec_helper'

describe Invoice do

  before(:each) do
    @customer = create(:customer)
    @bill = create(:bill, customer: @customer)
  end
  

  it "has a valid factory - given a valid customer with bill" do
    expect(create(:invoice, customer: @customer)).to be_valid
  end

  it "is valid with a customer with bills and a date" do
    invoice = Invoice.new(customer_id: @customer.id,
                                 date: "2014-02-01" )
    expect(invoice).to be_valid
  end

  it "is not valid without a customer_id" do
    invoice = Invoice.new(customer_id: "",
                                 date: "2014-02-01")
    expect(invoice).to have(1).errors_on(:customer_id)
  end
  
  it "is not valid with no bills" do
    customer = create(:customer)
    invoice = Invoice.new(customer: customer,
                              date: "2014-02-01")
    expect(invoice).to have(1).errors_on(:customer_id)
  end

  it "requires a date" do
    invoice = Invoice.new(customer: @customer, 
                              date: "")
    expect(invoice).to have(1).errors_on(:date)
  end

  it "responds to customer_name with the customer's name" do
    invoice = Invoice.new(customer_id: @customer.id,
                                 date: "2014-02-01" )
    expect(invoice.customer_name).to eq @customer.name
  end

  it "calculates the next number" do
    account = mock_model('Account')
    account.stub(:id).and_return(1)
    invoice1 = Invoice.create(customer_id: @customer.id,
                                     date: "2014-02-01",
                               account_id: "1",
                                   number: "1" )
    expect(Invoice.next_number(account)).to eq "2"
  end

  it "calculates the next number within its account group" do
    account = mock_model('Account')
    account.stub(:id).and_return(1)
    invoice1 = Invoice.create(customer_id: @customer.id,
                                     date: "2014-02-01",
                               account_id: "2",
                                   number: "1" )
    expect(Invoice.next_number(account)).to eq "1"
  end

end
