class Customer < ActiveRecord::Base
  belongs_to :account
  has_many :bills

  validates :name, presence: true

  def total
    bills.sum(:amount)
  end
end
