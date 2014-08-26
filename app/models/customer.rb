class Customer < ActiveRecord::Base
  # include Visible
  
  belongs_to :account
  has_many :bills
  has_many :invoices

  scope :is_default, -> { where(is_default: true) }

  validates :name, :account_id, presence: true
  before_destroy :check_has_no_bills?
  before_save :check_default

  # default_scope {where(account_id: Account.current_id)}

  def total
    bills.sum(:amount)
  end

  def has_uninvoiced_bills?
    !bills.uninvoiced.empty?
  end

  def default_customer
    self.is_default?
  end

  private

  def check_has_no_bills?
    # false will stop the delete
    self.bills.empty?
  end

  def check_default
    falsify_all_others if self.is_default?
  end

  def falsify_all_others
    self.class.where('id <> ? and account_id = ? and is_default', self.id, self.account_id).update_all("is_default = 'false'")
  end
end
