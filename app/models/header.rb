class Header < ActiveRecord::Base
  belongs_to :account
  has_many :invoices
end
