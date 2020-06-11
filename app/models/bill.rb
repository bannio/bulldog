class Bill < ActiveRecord::Base
  # include Visible

  belongs_to :account
  belongs_to :customer
  belongs_to :supplier
  belongs_to :category
  belongs_to :vat_rate
  belongs_to :invoice

  validates :date, date: true
  # validates :account_id, :date, :customer, :supplier, :category, :amount, presence: true
  validates :account_id, :date, :customer_id, :supplier_id, :category_id, :amount, presence: true
  # validates_associated :supplier, :category, :customer
  validates :amount, numericality: true

  # attr_accessor :new_category, :new_supplier, :new_customer
  # before_save :create_category, :create_customer #, :create_supplier,
  before_destroy :check_for_invoice

  scope :uninvoiced, -> {where(invoice_id: nil)}
  scope :this_year, -> {where(date: Time.now.all_year)}
  scope :last_year, -> {where(date: Time.now.prev_year.all_year)}
  scope :vat,       -> (rate){where(vat_rate_id: rate.id)}

  def customer_name
    customer ? customer.name : "Missing - please edit"
  end
  def supplier_name
    supplier ? supplier.name : "Missing - please edit"
  end
  def category_name
    category ? category.name : "Missing - please edit"
  end
  def excl_vat
    vat ? amount - vat : amount
  end
  def vat_rate_name
    vat_rate_id ? vat_rate.name : ""
  end
  def vat_rate_value
    vat_rate_id ? vat_rate.rate.to_s : ""
  end
  def invoice_number
    invoice_id ? invoice.number : ""
  end

  def self.to_csv(options = {})
    return unless first # at least one bill
    if first.account.business?
      CSV.generate(options) do |csv|
        csv << %w{Date Customer Supplier Category Description Amount VAT_rate VAT Invoice}
        all.each do |bill|
          row = [bill.date, bill.customer_name, bill.supplier_name, bill.category_name,
                bill.description, bill.amount, bill.vat_rate_name, bill.vat, bill.invoice_number]
          csv << row
        end
      end
    else
    CSV.generate(options) do |csv|
      csv << %w{Date Customer Supplier Category Description Amount Invoice}
      all.each do |bill|
        row = [bill.date, bill.customer_name, bill.supplier_name, bill.category_name,
              bill.description, bill.amount, bill.invoice_number]
        csv << row
      end
    end
    end
  end

  def self.import(file, account)
    # used to manually (via console) import from old bulldog
    # account should be empty of bills
    CSV.foreach(file, headers: true) do |row|
      bill = new
      imported = row.to_hash
      bill.date = imported['transaction_date']
      bill.customer = account.customers.find_or_create_by(name: imported['customer'])
      bill.supplier = account.suppliers.find_or_create_by(name: imported['supplier'])
      bill.category = account.categories.find_or_create_by(name: imported['category'])
      bill.description = imported['description']
      bill.amount = imported['amount']
      bill.invoice_id = imported['invoice_id']
      bill.account_id = account.id
      bill.save!
    end
  end

  def self.update_invoice_ids(invoice)
    # used to update bills via console after invoices are loaded
    number = invoice.number.to_i + 5000
    bills = Bill.where(invoice_id: number, account_id: invoice.account_id)
    bills.each do |bill|
      bill.update_attribute(:invoice_id, invoice.id)
    end
  end

  MNTHS = %w[Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec]

  def self.last_year_by_monthly_sum
    q = last_year.monthly_sum
    result = {}
    12.times{|i| result[MNTHS[i]] = q[i+1] || 0.0}
    result
  end

  def self.this_year_by_monthly_sum
    q = this_year.monthly_sum
    result = {}
    12.times{|i| result[MNTHS[i]] = q[i+1] || 0.0}
    result
  end

  def self.this_year_by_monthly_count
    q = this_year.monthly_count
    result = {}
    12.times{|i| result[MNTHS[i]] = q[i+1] || 0.0}
    # result
    {name: this_year_label, data: result}
  end

  def self.last_year_by_monthly_count
    q = last_year.monthly_count
    result = {}
    12.times{|i| result[MNTHS[i]] = q[i+1] || 0.0}
    # result
    {name: last_year_label, data: result}
  end

  def self.last_year_label
    Date.today.prev_year.year.to_s
  end

  def self.this_year_label
    Date.today.year.to_s
  end

  # If timestamp is required for Y-axis then you can use groupdate functions e.g. group_by_month
  # This monthly_sum method returns integers 1 to 12 to represent months so that multiple years can be laid
  # over each other in chartkick charts. Note that this is only available for bar or column charts.
  def self.monthly_sum
    order("cast(EXTRACT(month FROM date) as integer)").
    group("cast(EXTRACT(month FROM date) as integer)").
    sum(:amount)
  end


  def self.monthly_count
    order("cast(EXTRACT(month FROM date) as integer)").
    group("cast(EXTRACT(month FROM date) as integer)").
    count
  end


  private

  # def create_customer
  #   self.customer = Customer.create(name: new_customer, account_id: self.account_id) if new_customer.present?
  # end

  # def create_category
  #   self.category = Category.create(name: new_category, account_id: self.account_id) if new_category.present?
  # end

  # def create_supplier
  #   self.supplier = Supplier.create(name: new_supplier, account_id: self.account_id) if new_supplier.present?
  # end

  def check_for_invoice
    unless self.invoice_id.blank?
      errors.add(:amount, "This bill is invoiced and cannot be deleted")
      throw :abort
    end
  end
end
