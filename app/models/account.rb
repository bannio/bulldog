class Account < ActiveRecord::Base
  belongs_to :user
  has_many :suppliers
  has_many :customers
  has_many :categories
  has_many :bills

  validates :user_id, :name, presence: true

  # scope :owned_by_user, -> { where(user_id: current_user.id) }

  def self.owned_by_user(user)
    where(user_id: user.id)
  end

end
