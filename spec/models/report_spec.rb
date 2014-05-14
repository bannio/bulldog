require 'spec_helper'

describe "Report" do
  before do
    @attr = {
      account_id: 1,
      to_date: '2014-01-01',
      from_date: '2013-01-01',
      customer_id: 1,
      supplier_id: 1,
      category_id: 1
    }
  end
  it "is valid with valid attributes" do
    expect(Report.new(@attr)).to be_valid
  end 
  it "is not valid with no account_id" do
    expect(Report.new(@attr.merge(account_id: ""))).to_not be_valid
  end
  it "only needs account_id" do
    expect(Report.new(account_id: 1)).to be_valid
  end

  it "can generate a list of bills" do
    bill = create(:bill)
    report = Report.new(account_id: bill.account_id)
    expect(report.generate).to eq [bill]
  end

  it "validates to and from dates" do
    expect(Report.new(@attr.merge(from_date: "20114-01"))).to_not be_valid
    expect(Report.new(@attr.merge(to_date: "2014-01"))).to_not be_valid
    expect(Report.new(@attr.merge(to_date: "2014-01-33"))).to_not be_valid
  end

  it "accepts blank dates" do
    expect(Report.new(@attr.merge(from_date: ""))).to be_valid
    expect(Report.new(@attr.merge(to_date: ""))).to be_valid
  end

  it "validates that to is later than or equal to from" do
    expect(Report.new(@attr.merge(from_date: "2014-02-02", to_date: "2014-01-01"))).to_not be_valid
    expect(Report.new(@attr.merge(from_date: "2014-02-02", to_date: "2014-02-02"))).to be_valid
  end

end