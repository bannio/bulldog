class Account < ActiveRecord::Base
  belongs_to :user
  has_many :suppliers
  has_many :customers
  has_many :categories
  has_many :bills
  has_many :vat_rates
  has_many :headers
  has_one  :setting

  # accepts_nested_attributes_for :setting
  after_create :add_setting

  validates :user_id, :name, presence: true

  # scope :owned_by_user, -> { where(user_id: current_user.id) }

  def self.owned_by_user(user)
    where(user_id: user.id)
  end

  def include_bank_details?
    self.include_bank
  end

  private

  def add_setting
    create_setting
  end

end
