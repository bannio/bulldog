class Customer < ActiveRecord::Base
  belongs_to :account
  has_many :bills

  validates :name, :account_id, presence: true
  before_destroy :check_has_no_bills?

  def total
    bills.sum(:amount)
  end

  private

  def check_has_no_bills?
    # false will stop the delete
    self.bills.empty?
  end
end
