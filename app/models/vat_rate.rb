class VatRate < ActiveRecord::Base
  include Visible
  belongs_to :account
  has_many :bills

  validates :name, :rate, presence: true
  validates :rate, numericality: true

  before_destroy :check_for_bills

  private

  def check_for_bills
    self.bills.empty?
  end
end
