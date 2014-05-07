class Invoice < ActiveRecord::Base
  include Visible
  belongs_to :account
  belongs_to :customer
  belongs_to :header
  has_many   :bills

  #scope :current, -> { where(account_id: current_account.id) }

  validates_uniqueness_of :number, scope: :account_id
  validates :customer_id, :date, presence: true

  validate :customer_has_uninvoiced_bills?, on: :create

  attr_accessor :new_header
  before_save :create_header

  def self.next_number(account)
    self.where(account_id: account.id).last ? self.where(account_id: account.id).last.number.next : '1'
  end

  def customer_name
    customer.name
  end

  def header_name
    header ? header.name : ""
  end

  def setting
    account.setting
  end
  def include_bank_details?
    include_bank
  end

  def include_vat?
    include_vat
  end
  
  private

  def customer_has_uninvoiced_bills?
    unless self.customer.blank?
      if self.customer.has_uninvoiced_bills? 
        return true
      else
        errors.add(:customer_id, "This customer has no bills")
        return false
      end
    else
      # errors.add(:customer_id, "can't be blank")
      return false
    end
  end

  def self.customer_filter(customer)
    if customer.present?
      where(customer_id: customer)
    else
      all
    end
  end

  def self.search(search)
    if search.present?
      # where('customer_id in (select id from customers where name ilike :q)', q: "%#{search}%")
      where('comment ilike :q', q: "%#{search}%")

    else
      all
    end
  end

  def create_header
    self.header = Header.create(name: new_header, account_id: self.account_id) if new_header.present?
  end
end
