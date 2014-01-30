class Bill < ActiveRecord::Base
  belongs_to :account
  belongs_to :customer
  belongs_to :supplier
  belongs_to :category

  validates :account_id, :date, :customer_id, :supplier_id, :category_id, :amount, presence: true
end
