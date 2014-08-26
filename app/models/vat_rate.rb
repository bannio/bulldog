class VatRate < ActiveRecord::Base
  belongs_to :account
  has_many :bills

  validates :name, :rate, presence: true
  validates :rate, numericality: true
  validates :name, uniqueness: { scope: [:account, :active],
    message: "There is already an active rate with this name"}, if: :active

  validate :rate_in_use, on: :update

  before_destroy :check_for_bills

  scope :active, -> { where(active: true) }

  private

  def check_for_bills
    self.bills.empty?
  end

  def rate_in_use
    errors.add(:rate, "% rate already in use on bills") unless self.bills.empty? || !self.rate_changed?
  end

end
