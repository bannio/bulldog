class Account < ActiveRecord::Base
  belongs_to :user
  has_many :suppliers
  has_many :customers
  has_many :categories
  has_many :bills
  has_many :invoices
  has_many :vat_rates
  has_many :headers
  has_many :sales
  has_one  :setting
  belongs_to :plan

  after_create  :create_setting

  validates :name, :email, :plan_id, presence: true
  validates :email, uniqueness: true, format: {with: /\A[^@]+@[^@]+\z/}, on: :create

  # scope :owned_by_user, -> { where(user_id: current_user.id) }
  attr_accessor :stripe_card_token, :mail_list

  # Stripe Plans: 1: Personal annual, 2: Business monthly, 3: Business annual

  PLANS = { 1 => :personal, 2 => :business, 3 => :business }

  def subscription_type
    PLANS[plan_id]
  end

  def business?
    subscription_type == :business
  end

  def personal?
    subscription_type == :personal
  end

  def active?
    plan_id.present? && plan_id > 0
  end

  def self.owned_by_user(user)
    where(user_id: user.id)
  end

  def owner
    user
  end

  def customer(id)
    customers.find(id)
  end

  def supplier(id)
    suppliers.find(id)
  end

  def category(id)
    categories.find(id)
  end

  def bill(id)
    bills.find(id)
  end

  def invoice(id)
    invoices.find(id)
  end

  def vat_allowed?
    vat_enabled? && business?
  end

  # def process_subscription
  #   if create_stripe_customer
  #     process_sale
  #   else
  #     return false
  #   end
  # end

  private

  # def process_sale
  #   ProcessSale.new(self).process
  # end

  # def create_stripe_customer
  #   # if valid? && stripe_card_token.present?
  #   if stripe_card_token.present?
  #     customer = Stripe::Customer.create(
  #       description: "Customer for #{email}",
  #       card:         stripe_card_token,
  #       email:        email
  #       )
  #     self.stripe_customer_token = customer.id
  #   end
  # rescue Stripe::InvalidRequestError, Stripe::CardError => e
  #   logger.error {"Stripe error while creating customer: #{e.message}"}
  #   errors.add :base, "There was a problem with your payment card: #{e.message}"
  #   false
  # end

end
