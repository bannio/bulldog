require 'rails_helper'

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
    expect(invoice).to_not be_valid
  end

  it "is not valid with no bills" do
    customer = create(:customer)
    invoice = Invoice.new(customer: customer,
                              date: "2014-02-01")
    expect(invoice).to_not be_valid
    # expect(invoice).to have(1).errors_on(:customer_id)
  end

  it "requires a date" do
    invoice = Invoice.new(customer: @customer,
                              date: "")
    # expect(invoice).to have(1).errors_on(:date)
    expect(invoice).to_not be_valid
  end

  it "responds to customer_name with the customer's name" do
    invoice = Invoice.new(customer_id: @customer.id,
                                 date: "2014-02-01" )
    expect(invoice.customer_name).to eq @customer.name
  end

  it "calculates the next number" do
    account = double('Account')
    allow(account).to receive(:id){1}
    invoice1 = Invoice.create(customer_id: @customer.id,
                                     date: "2014-02-01",
                               account_id: "1",
                                   number: "1" )
    expect(Invoice.next_number(account)).to eq "2"
  end

  it "calculates the next number within its account group" do
    account = double('Account')
    allow(account).to receive(:id){1}
    invoice1 = Invoice.create(customer_id: @customer.id,
                                     date: "2014-02-01",
                               account_id: "2",
                                   number: "1" )
    expect(Invoice.next_number(account)).to eq "1"
  end

  it "knows its header" do
    header = create(:header, name: "Invoice")
    invoice = Invoice.new(header_id: header.id )
    expect(invoice.header_name).to eq "Invoice"
  end

  it "can create a new header" do
    invoice = Invoice.new(customer_id: @customer.id,
                                 date: "2014-02-01",
                                 new_header: "Test Header" )
    expect(invoice.header_id).to be_blank
    invoice.instance_eval{create_header}
    expect(invoice.header_id).to_not be_blank
  end

  it "can filter by from and to dates" do
    customer2 = create(:customer)
    bill = create(:bill, customer: customer2)
    invoice = create(:invoice, customer_id: @customer.id, date: "2013-05-01")
    invoice2 = create(:invoice, customer_id: customer2.id, date: "2014-05-01")
    expect(Invoice.filter_from("2013-12-01")).to eq [invoice2]
    expect(Invoice.filter_from("2012-01-01")).to eq [invoice, invoice2]
    expect(Invoice.filter_from("")).to eq [invoice, invoice2]
    expect(Invoice.filter_from("2014-12-01")).to eq []
    expect(Invoice.filter_to("2014-12-01")).to eq [invoice, invoice2]
    expect(Invoice.filter_to("2013-12-01")).to eq [invoice]
    expect(Invoice.filter_to("2012-12-01")).to eq []
    expect(Invoice.filter_to("")).to eq [invoice, invoice2]
  end

  it "can filter by customer" do
    customer2 = create(:customer)
    customer3 = create(:customer)
    bill = create(:bill, customer: customer2)
    invoice = create(:invoice, customer: @customer)
    invoice2 = create(:invoice, customer: customer2)
    expect(Invoice.where(customer_id: @customer.id)).to match_array invoice
    expect(Invoice.customer_filter({customer_id: @customer.id})).to match_array [invoice]
    expect(Invoice.customer_filter({customer_id: customer2.id})).to match_array [invoice2]
    expect(Invoice.customer_filter({customer_id: ""})).to match_array [invoice, invoice2]
    expect(Invoice.customer_filter({customer_id: customer3.id})).to match_array []
  end

  it "can search by comment" do
    customer2 = create(:customer)
    bill = create(:bill, customer: customer2)
    invoice = create(:invoice, customer_id: @customer.id, comment: "Test one")
    invoice2 = create(:invoice, customer_id: customer2.id, comment: "test two")
    expect(Invoice.search("test")).to eq [invoice, invoice2]
    expect(Invoice.search("TEST")).to eq [invoice, invoice2]
    expect(Invoice.search("")).to eq [invoice, invoice2]
    expect(Invoice.search("two")).to eq [invoice2]
    expect(Invoice.search("ONE")).to eq [invoice]
    expect(Invoice.search("xyz")).to eq []
  end

end
