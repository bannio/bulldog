require 'rails_helper'


describe Bill do
  before do
    @attr = {
      account_id: 1,
      date: '20140101',
      customer_id: 1,
      supplier_id: 1,
      category_id: 1,
      description: "",
      amount: "1",
      new_customer: "",
      new_supplier: "",
      new_category: ""
    }
  end

  it "is valid with valid attributes" do
    expect(Bill.new(@attr)).to be_valid
  end

  it "is invalid without date" do
    expect(Bill.new(@attr.merge(date: ""))).to_not be_valid
  end

  it "is invalid without customer_id" do
    expect(Bill.new(@attr.merge(customer_id: ""))).to_not be_valid
  end

  it "is invalid without supplier_id" do
    expect(Bill.new(@attr.merge(supplier_id: ""))).to_not be_valid
  end

  it "is invalid without account_id" do
    expect(Bill.new(@attr.merge(account_id: ""))).to_not be_valid
  end

  it "is invalid without category_id" do
    expect(Bill.new(@attr.merge(category_id: ""))).to_not be_valid
  end

  it "is invalid without amount" do
    expect(Bill.new(@attr.merge(amount: ""))).to_not be_valid
  end

  it "can name its customer, supplier etc." do
    customer = create(:customer_with_bill, name: 'John')
    supplier = create(:supplier, name: 'Fred')
    category = create(:category, name: 'Food')
    vat_rate = create(:vat_rate, name: 'standard')
    invoice =  create(:invoice, number: '99', customer_id: customer.id)
    bill = Bill.new(@attr.merge(customer_id: customer.id,
                                supplier_id: supplier.id,
                                category_id: category.id,
                                vat_rate_id: vat_rate.id,
                                invoice_id:  invoice.id))
    expect(bill.customer_name).to eq 'John'
    expect(bill.supplier_name).to eq 'Fred'
    expect(bill.category_name).to eq 'Food'
    expect(bill.vat_rate_name).to eq 'standard'
    expect(bill.invoice_number).to eq '99'
  end

  it "can name vat and invoice number even when these are missing" do
    bill = Bill.new(@attr.merge(vat_rate_id: nil,
                                invoice_id:  nil))
    expect(bill.vat_rate_name).to eq ''
    expect(bill.invoice_number).to eq ''
  end

  it "can accept a new customer" do
    expect(Bill.new(@attr.merge(customer_id: "A new customer"))).to be_valid
  end

  it "can accept a new supplier" do
    expect(Bill.new(@attr.merge(supplier_id: "A new supplier"))).to be_valid
  end

  it "can accept a new category" do
    expect(Bill.new(@attr.merge(category_id: "A new category"))).to be_valid
  end

  it "allocates the correct account to the new customer" do
    bill = Bill.create(@attr.merge(customer_id: "A new customer", new_customer: "A new customer"))
    expect(bill.customer.account_id).to eq bill.account_id
  end

  it "allocates the correct account to the new supplier" do
    bill = Bill.create(@attr.merge(supplier_id: "A new supplier", new_supplier: "A new supplier"))
    expect(bill.supplier.account_id).to eq bill.account_id
  end

  it "allocates the correct account to the new category" do
    bill = Bill.create(@attr.merge(category_id: "A new category", new_category: "A new category"))
    expect(bill.category.account_id).to eq bill.account_id
  end
end
