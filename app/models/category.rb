class Category < ActiveRecord::Base
  # include Visible
  belongs_to :account
  has_many :bills

  validates :name, presence: true
  validates :name, uniqueness: { scope: :account_id, 
    message: "This category already exists" ,
    case_sensitive: false }   # Food and food cannot co-exist
  before_destroy :check_for_bills

  def total
    bills.sum(:amount)
  end

  def reassign_bills_to(new_name)
    new_id = Category.where(account_id: self.account_id, name: new_name).first.id
    self.bills.each { |bill| bill.update_attribute(:category_id, new_id)}
  end

  private

  def check_for_bills
    unless self.bills.reload.empty?
      errors.add(:name, "This category has bills associated. Rename to reassign those bills") 
      false
    else
      true
    end
  end


end
