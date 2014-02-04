class Account < ActiveRecord::Base
  belongs_to :user
  has_many :suppliers
  has_many :customers
  has_many :categories
  has_many :bills

  validates :user_id, :name, presence: true

  # def self.current_id=(id)
  #   Thread.current[:account_id] = id
  # end
  
  # def self.current_id
  #   Thread.current[:account_id]
  # end
end
