class Bill < ActiveRecord::Base
  include Visible

  belongs_to :account
  belongs_to :customer
  belongs_to :supplier
  belongs_to :category

  validates :account_id, :date, :customer_id, :supplier_id, :category_id, :amount, presence: true

  attr_accessor :new_category, :new_supplier, :new_customer
  before_save :create_category, :create_supplier, :create_customer
  before_destroy :check_for_invoice

  scope :uninvoiced, -> {where(invoice_id: nil)}

  def customer_name
    customer.name
  end
  def supplier_name
    supplier.name
  end
  def category_name
    category.name
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << %w{Date Customer Supplier Description Amount Invoice}
      all.each do |bill|
        row = [bill.date, bill.customer_name, bill.supplier_name, 
              bill.description, bill.amount, bill.invoice_id]
        csv << row
      end     
    end
  end

  # def self.import(file)
  #   CSV.foreach(file.path, headers: true) do |row|
  #     bill = new
  #     bill.attributes = row.to_hash.slice(*accessible_attributes)
  #     bill.save!
  #   end
  # end 

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
