class Supplier < ActiveRecord::Base

# include Visible
  belongs_to :account
  has_many :bills

  validates :name, presence: true
  validates :name, uniqueness: { scope: :account_id,
    message: "This Supplier already exists" ,
    case_sensitive: false }   # Food and food cannot co-exist
  before_destroy :check_for_bills

  def total
    bills.sum(:amount)
  end

  def reassign_bills_to(new_name)
    new_id = Supplier.where(account_id: self.account_id, name: new_name).first.id
    self.bills.each { |bill| bill.update_attribute(:supplier_id, new_id)}
  end

  private

  def check_for_bills
    unless self.bills.reload.empty?
      errors.add(:name, "This Supplier has bills associated. Rename to reassign those bills")
      # false
      throw :abort
    else
      true
    end
  end
end
