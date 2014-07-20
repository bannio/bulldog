class Bill < ActiveRecord::Base
  include Visible

  belongs_to :account
  belongs_to :customer
  belongs_to :supplier
  belongs_to :category
  belongs_to :vat_rate
  belongs_to :invoice

  validates :date, date: true
  validates :account_id, :date, :customer_id, :supplier_id, :category_id, :amount, presence: true
  validates :amount, numericality: true

  attr_accessor :new_category, :new_supplier, :new_customer
  before_save :create_category, :create_supplier, :create_customer
  before_destroy :check_for_invoice

  scope :uninvoiced, -> {where(invoice_id: nil)}
  scope :this_year, -> {where(date: Time.now.all_year)}
  scope :last_year, -> {where(date: Time.now.prev_year.all_year)}
  scope :vat,       -> (rate){where(vat_rate_id: rate.id)}

  def customer_name
    customer.name
  end
  def supplier_name
    supplier.name
  end
  def category_name
    category.name
  end
  def vat_rate_name
    vat_rate_id ? vat_rate.name : ""
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
    # CSV.foreach(file.path, headers: true) do |row|
    CSV.foreach(file, headers: true) do |row|
      bill = new
      imported = row.to_hash
      puts imported  # delete this line!
      
      bill.date = imported['Date']
      bill.customer = Customer.find_or_create_by(name: imported['Customer'], account_id: account.id)
      bill.supplier = Supplier.find_or_create_by(name: imported['Supplier'], account_id: account.id)
      bill.category = Category.find_or_create_by(name: imported['Category'], account_id: account.id)
      bill.amount = imported['Amount']
      # vat_rate = imported.fetch('VAT_rate') {"Standard"}
      # puts "***** VAT rate was: #{vat_rate} *****"
      # bill.vat_rate_id = VatRate.find_or_create_by(name: vat_rate, account_id: account.id)
      # bill.vat = imported.fetch('VAT')
      bill.account_id = account.id
      bill.save!
    end
  end

  def self.import_from_psql(file, account)
    CSV.foreach(file, headers: true) do |row|
      row = row.to_hash
      # puts "ROW is: #{row}"
      unwanted = %w{created_at updated_at id}
      row = row.reject! {|k, v| unwanted.include?(k) }
      row = row.merge({'account_id' => account.id})
      # puts "ROW is now: #{row}"
      item = new(row)
      item.save
      # puts bill.inspect
      # puts bill.errors.full_messages
    end
  end

  def self.last_year_by_monthly_sum
    last_year.monthly_sum
  end

  def self.this_year_by_monthly_sum
    this_year.monthly_sum
  end

  # If timestamp is required for Y-axis then you can use groupdate functions e.g. group_by_month
  # This monthly_sum method returns integers 1 to 12 to represent months so that multiple years can be laid
  # over each other in chartkick charts. Note that this is only available for bar or column charts.
  def self.monthly_sum
    order("cast(EXTRACT(month FROM date) as integer)"). 
    group("cast(EXTRACT(month FROM date) as integer)").
    sum(:amount)
  end


  private

  def create_customer
    self.customer = Customer.create(name: new_customer, account_id: self.account_id) if new_customer.present?
  end

  def create_category
    self.category = Category.create(name: new_category, account_id: self.account_id) if new_category.present?
  end
  
  def create_supplier
    self.supplier = Supplier.create(name: new_supplier, account_id: self.account_id) if new_supplier.present?
  end

  def check_for_invoice
    unless self.invoice_id.blank?
      errors.add(:amount, "This bill is invoiced and cannot be deleted") 
      false
    end
  end
end
