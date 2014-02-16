class Bill < ActiveRecord::Base
  belongs_to :account
  belongs_to :customer
  belongs_to :supplier
  belongs_to :category

  validates :account_id, :date, :customer_id, :supplier_id, :category_id, :amount, presence: true

  attr_accessor :new_category, :new_supplier, :new_customer
  before_save :create_category, :create_supplier, :create_customer

  def customer_name
    customer.name
  end
  def supplier_name
    supplier.name
  end
  def category_name
    category.name
  end

  def create_customer
    self.customer = Customer.create(name: new_customer, account_id: self.account_id) if new_customer.present?
  end

  def create_category
    self.category = Category.create(name: new_category, account_id: self.account_id) if new_category.present?
  end
  
  def create_supplier
    self.supplier = Supplier.create(name: new_supplier, account_id: self.account_id) if new_supplier.present?
  end
end
